ARG IMAGE_ALPINE=node:21-alpine3.18
FROM $IMAGE_ALPINE

# make a pipe fail on the first failure
SHELL ["/bin/sh", "-o", "pipefail", "-c"]

# ensure we only use apk repositories over HTTPS (altough APK contain an embedded signature)
RUN echo "https://alpine.global.ssl.fastly.net/alpine/v$(cut -d . -f 1,2 < /etc/alpine-release)/main" > /etc/apk/repositories \
	&& echo "https://alpine.global.ssl.fastly.net/alpine/v$(cut -d . -f 1,2 < /etc/alpine-release)/community" >> /etc/apk/repositories

# The user the app should run as
ARG IMAGE_APP_USER=app
ENV APP_USER $IMAGE_APP_USER
# The home directory
ARG IMAGE_APP_DIR="/$APP_USER"
ENV APP_DIR $IMAGE_APP_DIR

# Update base system
RUN apk update && apk upgrade
RUN apk add --no-cache ca-certificates


# Remove users from base image
RUN  if id -u node &>/dev/null; then  deluser --remove-home node; fi

# Add custom user and setup home directory
RUN adduser -s /bin/true -u 1000 -D -h $APP_DIR $APP_USER \
  && chown -R "$APP_USER" "$APP_DIR" \
  && chmod 700 "$APP_DIR"

# Remove existing crontabs, if any.
RUN rm -fr /var/spool/cron \
	&& rm -fr /etc/crontabs \
	&& rm -fr /etc/periodic

# Remove all but a handful of admin commands.
RUN find /sbin /usr/sbin \
  ! -type d -a ! -name apk -a ! -name ln \
  -delete

# Remove world-writeable permissions except for /tmp/
RUN find / -xdev -type d -perm +0002 -exec chmod o-w {} + \
	&& find / -xdev -type f -perm +0002 -exec chmod o-w {} + \
	&& chmod 777 /tmp/ \
  && chown $APP_USER:root /tmp/


# Remove interactive login shell for everybody
RUN sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd

# Disable password login for everybody
RUN while IFS=: read -r username _; do passwd -l "$username"; done < /etc/passwd || true

# Remove temp shadow,passwd,group
RUN find /bin /etc /lib /sbin /usr -xdev -type f -regex '.*-$' -exec rm -f {} +

# Ensure system dirs are owned by root and not writable by anybody else.
RUN find /bin /etc /lib /sbin /usr -xdev -type d \
  -exec chown root:root {} \; \
  -exec chmod 0755 {} \;

# Remove suid & sgid files
RUN find /bin /etc /lib /sbin /usr -xdev -type f -a \( -perm +4000 -o -perm +2000 \) -delete

# Remove dangerous commands
RUN find /bin /etc /lib /sbin /usr -xdev \( \
  -iname hexdump -o \
  -iname chgrp -o \
  -iname ln -o \
  -iname od -o \
  -iname strings -o \
  -iname su -o \
  -iname sudo \
  \) -delete

# Remove init scripts since we do not use them.
RUN rm -fr /etc/init.d /lib/rc /etc/conf.d /etc/inittab /etc/runlevels /etc/rc.conf /etc/logrotate.d

# Remove kernel tunables
RUN rm -fr /etc/sysctl* /etc/modprobe.d /etc/modules /etc/mdev.conf /etc/acpi

# Remove root home dir
RUN rm -fr /root

# Remove fstab
RUN rm -f /etc/fstab

# Remove any symlinks that we broke during previous steps
RUN find /bin /etc /lib /sbin /usr -xdev -type l -exec test ! -e {} \; -delete

# set rx to all directories, except data directory/
RUN find "$APP_DIR" -type d -exec chmod 500 {} +

# set r to all files
RUN find "$APP_DIR" -type f -exec chmod 400 {} +

# chown all app files
RUN chown $APP_USER:$APP_USER -R $APP_DIR

# remove chown after use (links & binaries)
RUN find / \( -type f -o -type l \) -iname 'chown' -xdev -delete

# default directory is /app
WORKDIR $APP_DIR
