<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Project](#about-the-project)
* [Built With](#built-with)
* [Getting Started](#getting-started)
* [Prerequisites](#prerequisites)
* [Installation](#installation)
* [Roadmap](#roadmap)
* [Contributing](#contributing)
* [Contact](#contact)



<!-- ABOUT THE PROJECT -->
## About The Project

Jenkins setup with Terraform and helm.

### Built With

* [Terraform](https://terraform.io)
* [Jenkins](https://jenkins.com)


## Getting Started

Command to get Kubernetes config file that will create the file ~/.kube/config
```
$ aws eks update-kubeconfig --region eu-west-1 --name jenkins-prod
```

jenkins-prod is started via default workspace.

```
terraform workspace select prod
terraform plan -var-file=prod.tfvars
```

### Prerequisites

Terraform version 1.3.6 +

<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/m-stojanovic/terraform-jenkins-infrastructure/issues) for a list of proposed features (and known issues).

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- CONTACT -->
## Contact

Milos Stojanovic - [@linkedin]()

Project Link: [https://github.com/m-stojanovic/terraform-jenkins-infrastructure](https://github.com/m-stojanovic/terraform-jenkins-infrastructure)