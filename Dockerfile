# syntax=docker/dockerfile:1
FROM python:bullseye

# Install sudo and clear the apt cache in the same layer
RUN apt-get update && apt-get install -y --no-install-recommends sudo \
  && rm -rf /var/lib/apt/lists/*

# Create a non-root user and add it to the sudo group
# -r = system user
# -m = creates user's home directory
# -l = users login shell should be taken from '/etc/passwd'
# -g = pythonuser
# -s = /sbin/nologin -> set the shell to '/sbin/nologin'
# -c = "Pyhton user" -> adds comment indicating that it is the Python user pyhonuser
# && change password
# && adds the user to sudo group

RUN groupadd -r pythonuser \
  && useradd -r -m -l -g pythonuser -s /sbin/nologin -c "Python user" pythonuser \
  && echo pythonuser:pxl | chpasswd \
  && usermod -aG sudo pythonuser

# Set the working directory
WORKDIR /home/pythonuser

# Copy the Python script as the pythonuser user
COPY --chown=pythonuser:pythonuser hello.py .

# Switch to the non-root user
USER pythonuser

# Set the default command to execute
CMD ["python", "hello.py"]
