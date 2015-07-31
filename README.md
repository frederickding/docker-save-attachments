docker-save-attachments
=======================

This utility fetches emails regularly from an IMAP/POP3 account and saves the attachments to an output location, which can be a network file share.

It was originally designed to allow a dumb MFP to send scans to a folder on a NAS, despite it not supporting SFTP, NFS, or Samba. It can be adapted easily for any use case where you need to automatically pipe something emailed to simple files in simple storage.

## Usage

After retrieving this image, a container should be created with volumes mounted to

- `/config` (from which configuration files are loaded)
- `/output` (where attachments are saved)
- `/var/mail` (optional: where the email files are stored)

For instance, suppose the Docker host has mounted a network file share at `/mnt/nfs/mail`, and this is where attachments should go: 

```
docker create --name attachments -v /mnt/nfs/mailconfig:/config -v /mnt/nfs/mail:/output dingcorp/save-attachments
```

Then, the daemon can be started with

```
docker start attachments
```

Alternatively, these statements can be combined into one `docker run` command.

## Configuration

### `.fetchmailrc` (required)

You must tell `fetchmail` how to retrieve your email. Do this by creating a configuration file called `.fetchmailrc` in your `/config` volume. No default configuration is provided because that would be nonsensical.

Here's an example for Gmail:

```
poll imap.gmail.com protocol IMAP
	user "example@gmail.com" password "testing" is root here
keep
mimedecode
ssl
sslcertck
sslproto TLS1
```

You should omit any mail delivery agent (MDA) configuration flags, since that will be configured by the utility when the container is started. (A configuration line for maildrop will be added.)

### CA certificates (optional)

If you are connecting to an email server in a corporate environment that uses a self-signed certificate or a certificate issued by an enterprise certification authority, you can add CA certificates to be trusted as `*.crt` files in the `/config` volume. When the Docker container is started, these certificates are added to the CA trust store.

For example, suppose an IMAP server uses a certificate signed by Acme Intermediate CA, in turn signed by Acme Corporation Root CA, you should save those CA certificates as base64 PEM files as `/config/acme-intermediate-ca.crt` and `/config/acme-corporation-root-ca.crt`.

### Mounting network storage (optional)

This container by itself doesn't handle any storage configuration. Ideally, you should do so on the Docker host and pass a path to the container using `-v` to bind a volume.

You could also use a data volume container for `/output` and expose this directory to another containerized daemon (e.g. HTTP server), but that is again outside the scope of this image's functionality.
