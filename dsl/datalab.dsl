workspace {

    description "Datalab Platform V1"

    model {
        user = person "EOSC User"
        provider = person "Service provider"
        
        datalab = softwareSystem "Datalab Platform" "Provides the tools and resources for data analysis to the End User" {
        	dashboard = container "Datalab Portal" "Portal where the user customize the environment for the interactive analysis" "AngularJS" "dashboard"
            	api = container "Datalab API" "Provides the datalab functionality" "FastAPI"
            	environment = container "Interactive Environment" "Interactive environment with pre-installed tools"
            	environmentHub = container "Interactive Environment Hub" "Repo of interactive environments with the tools and computing resources for all projects" "JupyterHub" {
                	jupyterhub = component "Use case Namespace" "Provides the groupspace to create notebooks" "Jupyter Hub"
                	jupyterlab = component "User session" "Provides the user session for the analysis"
	        	services = component "Customized services" "Add more layers to the environment stack" "Tunned service"	
            	}
            	k8s = container "Container Management System" "Provides the resource cluster" "K8s"
            	jeg = container "Pre-installed kernel box" "The environment provides the tools and libraries for each analysis" "Jupyter Enterprise Gateway"
        	user -> this "Browses the environment for data analysis"
		user -> dashboard "Access to list or create the datalab workspace"
	        provider -> dashboard "Monitor the status of the platform"
        	dashboard -> api "Request the deployment or listing of interactive namespaces"
	}

        idsprocessing = softwareSystem "Streaming network processing" "Provides and resources for data analysis of specific use cases related to Massive Streaming Data" {
            
            kafka = container "Ingestion System" "Interactive environment for data ingestion and data persistence" "Apache Kafka"
	    StreamingSystem = group "Streaming" {
	    	fluentbit = container "Log collector" "Collects the network event logs" "Fluent Bit"
	    	promtail = container "Index collector" "Collects the register for monitoring system" "Promtail"
	    	loki = container "Log Aggregation system" "Aggregates the events and query data" "Grafana Loki"
	        monitoring = container "Monitoring System" "Dashboard where the network events are monitored" "Grafana"
	    }
	    BatchSystem = group "Batch" {
		spark = container "Streaming workflow" "Streaming Application for read, transform and store data in real time" "PySpark Streaming"
            #	advancedtools = container "Advanced tools & libraries" "advanced libraries for data optimized format, spark, ml tools" "python libs, delta lake, ceph"
            	advancedEnvironment = container "Advanced interactive environment" "Interactive environment with installed tools for advanced streaming analysis"
	    }

        }

        cluster = softwareSystem "Compute resources" "Execute the whole datalab platform and the environment containers" "OpenStack IaaS" {
		k8s -> this "Resource provisioning - Create cluster" 
        }
        sso = softwareSystem "EOSC Identity service" "Allows user access and permissions" "SSO" {
		datalab -> this "Authenticates users by"
		dashboard -> this "User needs to be logged in"
        } 
        storage = softwareSystem "Cloud Storage service" "Cloud Block and Object Storage where the datasets are stored" "Ceph Object RadosGW" {
		advancedEnvironment -> this "Load/Store data from/to"
		spark -> this "Stores data to"
		environment -> this "Load data stored in"
	}
        data = softwareSystem "Dataset Hub" "Source dataset for the analysis" {
		environment -> this "Download data from"
	}
        ids = softwareSystem "Intrusion Detection System" "Intrusion Detection System that creates network event logs" "Zeek" {
		fluentbit -> this "Collects logs from"
        }

        # Relationships
        k8s -> environment "Create interactive analysis environments"
        api -> k8s "Deploy the datalab namespaces and browse information about the current status" 

        user -> jupyterhub "Access to workspace"
        services -> k8s "Create services in"
        jupyterhub -> jupyterlab "Create user session"
        jupyterlab -> jeg "Define the kernel for each analysis with pre-installed libraries"

        #advancedEnvironment -> advancedtools "Uses for the analysis"
        monitoring -> loki "Query data from"
	advancedEnvironment -> datalab "Creates interactive analysis environments"
	kafka ->  datalab "Deploys the kafka cluster in"
        spark -> datalab "Deploys the spark application in"

	
        user -> advancedEnvironment "Access for analysis"
        spark -> kafka "Ingests data from"
        loki -> promtail "Indexes and aggregates data from"
        promtail -> kafka "Collects data from topic"
        fluentbit -> Kafka "Sends network events to"

	provider -> idsprocessing "Creates the whole IaaS"
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

	systemContext idsprocessing {
	    include *
	    include datalab
	    include ids
	    autoLayout lr
	}

        container idsprocessing {
            include *
            autoLayout 
        }

        #component environment {
        #    include *
        #    autoLayout
        #}

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
