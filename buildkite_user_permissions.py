import selenium
import subprocess
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import WebDriverException
from selenium.webdriver.common.by import By
import json
import datetime
# import CSV
## Add Structlog for observability
import structlog

structlog.configure(processors = [structlog.processors.JSONRenderer()])
log = structlog.get_logger()

# ## Connecting to amzon S3
import boto3

s3 = boto3.client('s3')
# print (full_url)
s3.upload_file("buildkite_user_urls.list","buildkite-user-audits-bucket", object_name= None)


##handler
def handler(event, context):
    start_time = datetime.datetime.now()
    log.msg(
            "Message from Lambda",
            function_name = context.function_name,
            function_version = context.function_version,
            # request_id = context.request_id,
            duration_ms = (datetime.datetime.now() - start_time).total_seconds()*1000
        )

    import json
    import urllib.parse

    # Get the object from the event and show its content type
    bucket = event['Records'][0]['s3']['bucket']['buildkite-user-audits-bucket']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['temp'], encoding='utf-8')
    print (key)
    try:
        response = s3.get_object(Bucket = bucket, Key= key)
        print("CONTENT TYPE: " + response['ContentType'])
        return response['ContentType']
    except Exception as e:
        print(e)
        print(
            'Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(
                key, bucket))
        raise e

    return {
            
            'headers': {'Content-Type' : 'application/json'},
            'statusCode': 200,
            'body': json.dumps({"message": "Buildkite user information gathered!",
                                "event": event})
    }

more_teams = True

button_class_xpath = '//button[@class="btn nowrap btn-default"]'

def click_show_more(driver):
    driver.find_element_by_xpath(button_class_xpath).click()

def get_more_teams(driver, delay):
    global more_teams
    try:
        WebDriverWait(driver, delay).until(
            EC.presence_of_element_located(
                (By.XPATH, button_class_xpath)
            )
        )
        click_show_more(driver)
    except selenium.common.exceptions.TimeoutException:
        more_teams = False
        return

def get_more_users(driver, delay):
    print("get more users")
    global more_users
    try:
        WebDriverWait(driver, delay).until(
            EC.presence_of_element_located(
                (By.XPATH, button_class_xpath)
            )
        )
        click_show_more(driver)
        print("click")
    except selenium.common.exceptions.TimeoutException:
        more_users = False
        return

options = webdriver.ChromeOptions()
options.binary_location = '/opt/chrome/chrome'
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument("--disable-gpu")
options.add_argument("--single-process")
options.add_argument("--disable-dev-shm-usage")
options.add_argument("--disable-dev-tools")
options.add_argument("--no-zygote")
options.add_argument("--window-size=1920,1080")
driver = webdriver.Chrome("/opt/chromedriver",options=options)

email_user = ""
email_password = ""

driver.get("https://buildkite.com/login")
driver.get_screenshot_as_file("login.png")

email = driver.find_element_by_name('login[email]')
email.send_keys(email_user)

password = driver.find_element_by_name('login[password]')
password.send_keys(email_password)

driver.find_element_by_name("commit").click()
driver.get("")

more_users = True

while more_users:
    print("start getting users")
    get_more_users(driver, 10)

with open('/tmp/buildkite_users.html', mode='w', encoding='utf-8') as f:
    data=f.write(driver.page_source)
    print ("print test 3", data )
    f.close()

subprocess.run("./buildkite_user_permissions.sh")
user_urls = ""

with open('/tmp/buildkite_user_urls.list', 'r') as file:
    user_urls = file.readlines()
    file.close() #

user_urls = [line.rstrip() for line in user_urls]
print("Print the test 1",user_urls)

for rawUrlLine in user_urls:
    url = rawUrlLine.replace("\x00", "")
    full_url="http://buildkite.com" + url + "/teams"
    print("Print the test 2",full_url)
    driver.get(full_url)
# filename= buildkite_user_permission

    while more_teams:
        get_more_teams(driver, 5)

    with open('/temp/' + url[-36:], 'w') as f:
        f.write(driver.page_source)
        f.close()
driver.quit()