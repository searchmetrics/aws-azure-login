# aws-azure-login
If your organization uses [Azure Active Directory](https://azure.microsoft.com) to provide SSO login to the AWS console, then there is no easy way to log in on the command line or to use the [AWS CLI](https://aws.amazon.com/cli/). This tool fixes that. It lets you use the normal Azure AD login (including MFA) from a command line to create a federated AWS session and places the temporary credentials in the proper place for the AWS CLI and SDKs.

#### Changes from Upstream
- Does not publish to only to docker hub.Not to npm packages.
- Alpine image with latest pupteer is used for security fixes and small image
- Launch script have flags for `debug` and `latest` image.

## Requirements
- [aws cli  ](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) must be installed. For running aws commands.

## Installation

### Docker


You can also put the `docker-launch-alpine.sh` script into your bin directory for the aws-azure-login command to function as usual (**recommended** method):

    sudo curl -o /usr/local/bin/aws-azure-login https://raw.githubusercontent.com/searchmetrics/aws-azure-login/master/docker-launch-alpine.sh
    sudo chmod o+x /usr/local/bin/aws-azure-login

Now just run `aws-azure-login`.

This script is basically a wrapper for running Docker image has been built with aws-azure-login preinstalled. You can also simply  run the command with a volume mounted to your AWS configuration directory.

    docker run --rm -it -v ~/.aws:/root/.aws searchmetrics/aws-azure-login
    
The Docker image is configured with an entrypoint so you can just feed any arguments in at the end.


## Usage

### Configuration
A configuration file is shared internaly to simplify the configuration. This file should be saved as `~/.aws/config`. 

#### AWS

To configure the aws-azure-login client run:

    aws-azure-login --configure
    
You'll need your Azure Tenant ID and the App ID URI. To configure a named profile, use the --profile flag.

    aws-azure-login --configure --profile foo

#### Environment Variables

You can optionally store your responses as environment variables:

* `AZURE_TENANT_ID`
* `AZURE_APP_ID_URI`
* `AZURE_DEFAULT_USERNAME`
* `AZURE_DEFAULT_PASSWORD`
* `AZURE_DEFAULT_ROLE_ARN`
* `AZURE_DEFAULT_DURATION_HOURS`

To avoid having to ``<Enter>`` through the prompts after setting these environment variables, use the `--no-prompt` option when running the command.

    aws-azure-login --no-prompt

Use the `HISTCONTROL` environment variable to avoid storing the password in your bash history (notice the space at the beginning):

    $ HISTCONTROL=ignoreboth
    $  export AZURE_DEFAULT_PASSWORD=mypassword
    $ aws-azure-login

### Logging In

Once aws-azure-login is configured, you can log in. For the default profile, just run:

    aws-azure-login
    
You will be prompted for your username and password. If MFA is required you'll also be prompted for a verification code or mobile device approval. To log in with a named profile:

    aws-azure-login --profile foo

Alternatively, you can set the `AWS_PROFILE` environmental variable to the name of the profile just like the AWS CLI.

Once you log in you can use the AWS CLI or SDKs as usual!

If you are logging in on an operating system with a GUI, you can log in using the actual Azure web form instead of the CLI:

    aws-azure-login --mode gui

Logging in with GUI mode is likely to be much more reliable.

_Note:_ on Linux you will likely need to disable the Puppeteer sandbox or Chrome will fail to launch:

    aws-azure-login --no-sandbox


## Troubleshooting

The nature of browser automation with Puppeteer means the solution is bit brittle. A minor change on the Microsoft side could break the tool. If something isn't working, you can fall back to GUI mode (above). To debug an issue, you can run in debug mode (--mode debug) to see the GUI while aws-azure-login tries to populate it. You can also have the tool print out more detail on what it is doing to try to do in order to diagnose. aws-azure-login uses the [Node debug module](https://www.npmjs.com/package/debug) to print out debug info. Just set the DEBUG environmental variable to 'aws-azure-login'. On Linux/OS X:

    DEBUG=aws-azure-login aws-azure-login

On Windows:

    set DEBUG=aws-azure-login
    aws-azure-login

## Support for Other Authentication Providers

Obviously, this tool only supports Azure AD as an identity provider. However, there is a lot of similarity with how other logins with other providers would work (especially if they are SAML providers). If you are interested in building support for a different provider let me know. It would be great to build a more generic AWS CLI login tool with plugins for the various providers.
