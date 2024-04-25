FROM openjdk:8
EXPOSE 8080
ADD target/springboot-crud-k8s-integration.jar springboot-crud-k8s-integration.jar
ENTRYPOINT ["java","-jar","/springboot-crud-k8s-integration.jar"]
