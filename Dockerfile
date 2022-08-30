FROM public.ecr.aws/lambda/python@sha256:9c083b42c52a41c378bf08e6dc64e7ed17be39166681ecd1963a1eb45200f3ca as build
RUN yum install -y unzip && \
    curl -Lo "/tmp/chromedriver.zip" "https://chromedriver.storage.googleapis.com/103.0.5060.134/chromedriver_linux64.zip" && \
    curl -Lo "/tmp/chrome-linux.zip" "https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F1002910%2Fchrome-linux.zip?alt=media" && \
    unzip /tmp/chromedriver.zip -d /opt/ && \
    unzip /tmp/chrome-linux.zip -d /opt/

FROM public.ecr.aws/lambda/python@sha256:9c083b42c52a41c378bf08e6dc64e7ed17be39166681ecd1963a1eb45200f3ca
RUN yum install atk cups-libs gtk3 libXcomposite alsa-lib \
    libXcursor libXdamage libXext libXi libXrandr libXScrnSaver \
    libXtst pango at-spi2-atk libXt xorg-x11-server-Xvfb \
    xorg-x11-xauth dbus-glib dbus-glib-devel -y \

RUN pip install selenium==4.2.0 htmlq
RUN pip install requests
COPY --from=build /opt/chrome-linux /opt/chrome
COPY --from=build /opt/chromedriver /opt/

ENV FUNCTION_DIR="/var/task"

#FROM public.ecr.aws/lambda/python@sha256:9c083b42c52a41c378bf08e6dc64e7ed17be39166681ecd1963a1eb45200f3ca
RUN mkdir -p /opt/extensions
RUN yum install -y curl
RUN curl -L  https://honeycomb.io/download/honeycomb-lambda-extension/v10.2.0/honeycomb-lambda-extension-arm64 -o /opt/extensions/honeycomb-lambda-extension
RUN chmod +x /opt/extensions/honeycomb-lambda-extension
RUN pip install selenium==4.2.0 htmlq
RUN pip install structlog
RUN pip install DateTime
RUN mkdir -p /var/task

COPY . /var/task

ENV LIBHONEY_API_KEY honeycomb-audit-api
ENV LIBHONEY_DATASET audit-scripts

# Copy function code to container
COPY buildkite_user_permissions.py ${LAMBDA_TASK_ROOT}
COPY buildkite_user_permissions.sh ${LAMBDA_TASK_ROOT}

# setting the CMD to your handler file_name.function_name
CMD [ "buildkite_user_permissions.handler" ]