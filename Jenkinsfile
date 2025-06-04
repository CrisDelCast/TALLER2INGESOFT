pipeline {
    agent any

    environment {
        KUBE_CONFIG = credentials('kubeconfig')
        NAMESPACE = 'ecommerce'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Microservices') {
            parallel {
                stage('Build API Gateway') {
                    steps {
                        build job: 'api-gateway-pipeline', wait: true
                    }
                }
                stage('Build Cloud Config') {
                    steps {
                        build job: 'cloud-config-pipeline', wait: true
                    }
                }
                stage('Build Service Discovery') {
                    steps {
                        build job: 'service-discovery-pipeline', wait: true
                    }
                }
                stage('Build Order Service') {
                    steps {
                        build job: 'order-service-pipeline', wait: true
                    }
                }
                stage('Build Product Service') {
                    steps {
                        build job: 'product-service-pipeline', wait: true
                    }
                }
                stage('Build User Service') {
                    steps {
                        build job: 'user-service-pipeline', wait: true
                    }
                }
            }
        }

        stage('Run Tests') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        build job: 'unit-tests-pipeline', wait: true
                    }
                }
                stage('Integration Tests') {
                    steps {
                        build job: 'integration-tests-pipeline', wait: true
                    }
                }
                stage('Performance Tests') {
                    steps {
                        build job: 'performance-tests-pipeline', wait: true
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                build job: 'k8s-deployment-pipeline', wait: true
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    // Verificar estado de los pods
                    sh '''
                        echo "Verificando estado de los pods..."
                        kubectl get pods -n ${NAMESPACE}
                        
                        echo "Verificando servicios..."
                        kubectl get services -n ${NAMESPACE}
                        
                        echo "Verificando deployments..."
                        kubectl get deployments -n ${NAMESPACE}
                    '''
                }
            }
        }
    }

    post {
        always {
            // Generar reporte de estado
            script {
                def report = """
                    ===== Estado del Pipeline =====
                    Fecha: ${new Date()}
                    
                    Microservicios:
                    ${getBuildStatus('api-gateway-pipeline')}
                    ${getBuildStatus('cloud-config-pipeline')}
                    ${getBuildStatus('service-discovery-pipeline')}
                    ${getBuildStatus('order-service-pipeline')}
                    ${getBuildStatus('product-service-pipeline')}
                    ${getBuildStatus('user-service-pipeline')}
                    
                    Pruebas:
                    ${getBuildStatus('unit-tests-pipeline')}
                    ${getBuildStatus('integration-tests-pipeline')}
                    ${getBuildStatus('performance-tests-pipeline')}
                    
                    Despliegue:
                    ${getBuildStatus('k8s-deployment-pipeline')}
                """
                
                // Guardar reporte
                writeFile file: 'pipeline-status-report.txt', text: report
                
                // Publicar reporte
                publishHTML([
                    allowMissing: true,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: '.',
                    reportFiles: 'pipeline-status-report.txt',
                    reportName: 'Pipeline Status Report',
                    reportTitles: 'Pipeline Status'
                ])
            }
        }
        success {
            echo 'Pipeline principal completado exitosamente!'
        }
        failure {
            echo 'Pipeline principal falló!'
        }
    }
}

// Función auxiliar para obtener el estado de un build
def getBuildStatus(String jobName) {
    def job = Jenkins.instance.getItem(jobName)
    if (job) {
        def lastBuild = job.getLastBuild()
        if (lastBuild) {
            return "${jobName}: ${lastBuild.getResult()}"
        }
    }
    return "${jobName}: No build found"
} 