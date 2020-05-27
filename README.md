# aws-azure-login
If your organization uses [Azure Active Directory](https://azure.microsoft.com) to provide SSO login to the AWS console, then there is no easy way to log in on the command line or to use the [AWS CLI](https://aws.amazon.com/cli/). This tool fixes that. It lets you use the normal Azure AD login (including MFA) from a command line to create a federated AWS session and places the temporary credentials in the proper place for the AWS CLI and SDKs.

#### Changes from Upstream
- Does not publish to only to docker hub.Not to npm packages.
- Alpine image with latest pupteer is used for security fixes and small image
- Launch script have flags for `debug` and `latest` image.

## Requirements
- [aws cli  ](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) must be installed. For running aws commands.
- A local Docker: https://docs.docker.com/install/

## Installation

### Docker


Install the command ( a wrapper that runs a dockerized command) in a folder in your path. It could be /usr/local/bin as shown below:

```SHELL
curl -sq https://raw.githubusercontent.com/searchmetrics/public_gists/master/installers/install.sh \
     | bash -s aws_azure_login
```

This script is basically a wrapper for running Docker image has been built with aws-azure-login preinstalled. You can also simply  run the command with a volume mounted to your AWS configuration directory.

```SHELL
docker run --rm -it -v ~/.aws:/root/.aws searchmetrics/aws-azure-login
```
The Docker image is configured with an entrypoint so you can just feed any arguments in at the end.


## Usage

### Setup
A configuration file is shared internaly to simplify the configuration. This file should be saved as `~/.aws/config`. 

You will also need our company *AZURE_TENANT_ID* and your *AZURE_APP_ID* which is associated to your AWS Account. You can find both listed in the link [List of Azure App Ids](https://searchmetrics.atlassian.net/l/c/MxSFhsiX).


### Configuration
To configure the default profile run:

```SHELL
aws-azure-login --configure
```

To configure an [AWS named profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) run:

```SHELL
aws-azure-login --configure --profile san
```

This will create the profile san in ~/.aws/config.. Answer the questions  similar to the example:

```SHELL
[profile dev]
azure_tenant_id=290fcf70-c0bd-4d9c-ab8e-a93624630763
azure_app_id_uri=09d3ae02-996c-4445-9911-5cd6e31ee9ce #for sandbox, will change per app
azure_default_username=r.sanchez@searchmetrics.com 
azure_default_role_arn=o365-developer # desired role
azure_default_duration_hours=3 # may also need to be increased for role in IAM console
```

We also suggests opening ~/.aws/config and adding

```SHELL
[profile san]
...
region=eu-west-1 
```

### Logging In

Once aws-azure-login is configured, you can log in. For the default profile, just run:

```SHELL
aws-azure-login
```

You will be prompted for your username and password. If MFA is required you'll also be prompted for a verification code or mobile device approval. To log in with a named profile:

```SHELL
aws-azure-login --profile san
```

Once you log in you can use the AWS CLI or SDKs as usual!

Test with something like 

```SHELL
aws --profle=san s3 ls
```
