Google Cloud Service Accounts, in Terraform
==============

To setup your Travis CI Enterprise installation to run the workers in GKE, and use Google Cloud instances for jobs, 
you need to setup service accounts which contain the required permissions for the components to run seemlessly.

### Setup

First of all, you'll need to clone this repository:

```
git clone https://github.com/travis-ci/gcp-enterprise-service-accounts
cd gcp-enterprise-service-accounts
```

Next, you will need to [install terraform](https://www.terraform.io/downloads.html):

```
# on macOS
brew install terraform
```

To authenticate the google provider, you should also [install the Google Cloud SDK](https://cloud.google.com/sdk/install), which includes the `gcloud` command-line tool.

```
# on macOS
brew tap caskroom/cask
brew cask install google-cloud-sdk
```

In order to authenticate with your Google Cloud account, you can run:

```
gcloud config set project <project>
gcloud auth login
gcloud auth application-default login
```

This is needed by later stages.


### Run

You can now go ahead and initialize terraform and run a `plan`, to see what terraform is about to create:

```
terraform init
terraform plan
```

It should spit out a large blob of text, with a plan to create an instance template, an instance group, and possibly more.

To actually create those resources, you can run `apply`:

```
terraform apply
```

You should see two big json blobs and an email address as the output, you will need these shortly.


### Image permissions

The Travis CI Worker requires access to pre-built job images in order to boot job VMs. You need to contact our Enterprise Support to get that set up.

When you run `terraform apply`, it should output a line similar to this one:

```
worker_service_account_email = travis-ci-worker@my-google-project-1234.iam.gserviceaccount.com
```

Please contact us at the [Support Portal](https://support.travis-ci.com/hc/en-us) or at [`enterprise@travis-ci.com`](mailto:enterprise@travis-ci.com), and provide the `worker_service_account_email` or the name of your Google Cloud project.
