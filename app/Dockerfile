
FROM python:3.11-slim AS build
WORKDIR /w
COPY requirements.txt .
RUN pip install --prefix=/out -r requirements.txt
COPY src/ ./src

FROM gcr.io/distroless/python3-debian12
WORKDIR /app
ENV PATH=/usr/local/bin:$PATH \
    PYTHONPATH=/app:/usr/local/lib/python3.11/site-packages \
    TABLE_NAME=ecs-v2

COPY --from=build /out/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=build /out/bin /usr/local/bin
COPY --from=build /w/src/ /app/

USER 65532:65532
EXPOSE 8080

CMD ["/usr/local/bin/uvicorn", "main:app", "--host=0.0.0.0", "--port=8080"]

# FROM python:3.12-slim AS build
# WORKDIR /w
# COPY requirements.txt .
# RUN pip install --prefix=/out -r requirements.txt
# COPY src/ ./src

# FROM gcr.io/distroless/python3-debian12
# ENV PYTHONPATH=/app \
#     TABLE_NAME=changeme
# WORKDIR /app
# COPY --from=build /out /usr/local
# COPY --from=build /w/src /app
# USER 65532:65532
# EXPOSE 8080
# CMD ["-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8080"]

# dynamodb table needs to be created first before running the container
