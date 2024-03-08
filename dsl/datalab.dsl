workspace {

    description "Datalab Platform V1"

    model {
        user = person "EOSC User"
        datalab = softwareSystem "Datalab Platform" "Provides the tools and resources for data analysis to the End User" {
            dashboard = container "Datalab Portal" "Portal where the user customize the environment for the interactive analysis" "AngularJS" "dashboard"
            api = container "Datalab API" "Provides the datalab functionality" "FastAPI"
            environment = container "Interactive Environment" "Interactive environment with pre-installed tools"
            environmentiHub = container "Interactive Environment Hub" "Repo of interactive environments with the tools and computing resources for all projects" "JupyterHub" {
                jupyterhub = component "Use case Namespace" "Provides the groupspace to create notebooks" "Jupyter Hub"
                jupyterlab = component "User session" "Provides the user session for the analysis"
	        services = component "Customized services" "Add more layers to the environment stack" "Tunned service"	
            }
            k8s = container "Container Management System" "Provides the resource cluster" "K8s"
            jeg = container "Pre-installed kernel box" "The environment provides the tools and libraries for each analysis" "Jupyter Enterprise Gateway"
        }

        datalabAdvanced = softwareSystem "Datalab Platform for the Streaming events analysis" "Provides and resources for data analysis of specific use cases related to Massive Streaming Data" {
            kafka = container "Message broker" "Distributed event platform for data ingestion" "Apache Kafka"
            spark = container "Streaming workflow" "Streaming Application for read, transform and store data in real time" "Python,Spark"
            advancedtools = container "Advanced tools & libraries" "advanced libraries for data optimized format, spark, ml tools" "python libs, delta lake"
            advancedEnvironment = container "Advanced interactive environment" "environment with installed tools for advanced streaming analysis"
            k8sA = container "Container Management System" "Provides the resource cluster" "K8s"
        }

        cluster = softwareSystem "Compute resources" "Execute the whole datalab platform and the environment containers" "OpenStack"
        sso = softwareSystem "EOSC Identity service" "Allows user access and permissions" "SSO"  
        storage = softwareSystem "Cloud Storage service" "Cloud Block and Object Storage where the datasets are stored" "OpenStack Storage"
        data = softwareSystem "Dataset Hub" "Source dataset for the analysis"
        sensor = softwareSystem "Sensor" "Application that creates real-time data"

        # Relationships
        user -> datalab "Browses the environment for data analysis"
        user -> dashboard "Access to list or create the datalab workspace"
        datalab -> sso "Authenticates users by"
        dashboard -> sso "User needs to be loigged in"
        dashboard -> api "Request the deployment or listing of interactive namespaces"
        
        k8s -> environment "Create interactive analysis environments"
        api -> k8s "Deploy the datalab namespaces and browse information about the current status" 
        environment -> storage "Load data stored in"
        environment -> data "Download data from"
        k8s -> cluster "resource provisioning - Create pool of Spark nodes"

        user -> jupyterhub "Access to workspace"
        services -> k8s "Create services in"
        jupyterhub -> jupyterlab "Create user session"
        jupyterlab -> jeg "Define the kernel for each analysis with pre-installed libraries"

        advancedEnvironment -> storage "Load/Store data from/to"
        advancedEnvironment -> advancedtools "Uses for the analysis"
        advancedEnvironment -> k8sA "Create interactive analysis environments"
        user -> advancedEnvironment "Access for analysis"
        kafka -> sensor "Collects data from" 
        spark -> kafka "Ingest data from"
        spark -> storage "Store data to"
        kafka -> k8sA "Deploy the kafka cluster in"
        spark -> k8sA "Deploy the spark application in"
    }

    views {
        theme Default

        systemContext datalab {
            include * 
            autoLayout
        }
   
        container datalab {
            include *
            autoLayout
        }

        container datalabAdvanced {
            include *
            autoLayout
        }

        component environment {
            include *
            autoLayout
        }

        styles {
            element "Container" {
                background #F9B572
                color black
            }

            element "Software System" {
                background #99B080
                color black
            }

            element "dashboard" {
                shape WebBrowser
            }

            element "storage" {
                shape Cylinder
            }
        }
    }
}
