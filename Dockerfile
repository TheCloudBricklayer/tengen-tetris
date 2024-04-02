FROM python:3.12-slim as builder

WORKDIR /app

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    gcc libc6-dev

COPY requirements.txt /app
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt

# assamble stage
FROM python:3.12-slim as app

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY app/. /app

COPY --from=builder /app/wheels /wheels

RUN pip install --no-cache /wheels/*

COPY entrypoint.sh /app

RUN chmod +x entrypoint.sh

# Expose the port on which the Flask API will run
EXPOSE 8080

# Set the entrypoint to the shell script
ENTRYPOINT [ "./entrypoint.sh" ]
