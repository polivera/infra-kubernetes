# apps/mysql/terraform/config.tf
resource "kubernetes_config_map" "mysql" {
  metadata {
    name      = "mysql-config"
    namespace = var.namespace
  }
  data = {
    MYSQL_DATABASE = "flipflow"
  }
}

resource "kubernetes_config_map" "druid_common" {
  metadata {
    name      = "druid-common-config"
    namespace = kubernetes_namespace.flipflow.metadata[0].name
  }

  data = {
    # Common runtime properties
    "common.runtime.properties" = <<-EOF
      # Extensions
      druid.extensions.loadList=["druid-hdfs-storage", "druid-kafka-indexing-service", "druid-datasketches", "postgresql-metadata-storage"]

      # Metadata storage
      druid.metadata.storage.type=postgresql
      druid.metadata.storage.connector.connectURI=jdbc:postgresql://postgres.${kubernetes_namespace.flipflow.metadata[0].name}.svc.cluster.local:5432/druid
      druid.metadata.storage.connector.user=druid
      druid.metadata.storage.connector.password=druid123

      # Deep storage
      druid.storage.type=local
      druid.storage.storageDirectory=/opt/shared/segments

      # Indexing logs
      druid.indexer.logs.type=file
      druid.indexer.logs.directory=/opt/shared/indexing-logs

      # Service discovery
      druid.selectors.indexing.serviceName=druid/overlord
      druid.selectors.coordinator.serviceName=druid/coordinator

      # Monitoring
      druid.monitoring.monitors=["org.apache.druid.java.util.metrics.JvmMonitor"]
      druid.emitter=noop

      # SQL
      druid.sql.enable=true

      # Zookeeper
      druid.zk.service.host=zookeeper.${kubernetes_namespace.flipflow.metadata[0].name}.svc.cluster.local:2181
      druid.zk.paths.base=/druid
    EOF

    # JVM config for coordinator
    "coordinator.jvm.config" = <<-EOF
      -server
      -Xms1g
      -Xmx1g
      -XX:+UseG1GC
      -XX:+ExitOnOutOfMemoryError
      -Duser.timezone=UTC
      -Dfile.encoding=UTF-8
      -Djava.io.tmpdir=var/tmp
      -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager
    EOF

    # JVM config for broker
    "broker.jvm.config" = <<-EOF
      -server
      -Xms1g
      -Xmx1g
      -XX:+UseG1GC
      -XX:+ExitOnOutOfMemoryError
      -Duser.timezone=UTC
      -Dfile.encoding=UTF-8
      -Djava.io.tmpdir=var/tmp
      -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager
      -XX:MaxDirectMemorySize=400m
    EOF

    # JVM config for historical
    "historical.jvm.config" = <<-EOF
      -server
      -Xms1g
      -Xmx1g
      -XX:+UseG1GC
      -XX:+ExitOnOutOfMemoryError
      -Duser.timezone=UTC
      -Dfile.encoding=UTF-8
      -Djava.io.tmpdir=var/tmp
      -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager
      -XX:MaxDirectMemorySize=400m
    EOF

    # JVM config for middleManager
    "middleManager.jvm.config" = <<-EOF
      -server
      -Xms1g
      -Xmx1g
      -XX:+UseG1GC
      -XX:+ExitOnOutOfMemoryError
      -Duser.timezone=UTC
      -Dfile.encoding=UTF-8
      -Djava.io.tmpdir=var/tmp
      -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager
    EOF

    # JVM config for router
    "router.jvm.config" = <<-EOF
      -server
      -Xms512m
      -Xmx512m
      -XX:+UseG1GC
      -XX:+ExitOnOutOfMemoryError
      -Duser.timezone=UTC
      -Dfile.encoding=UTF-8
      -Djava.io.tmpdir=var/tmp
      -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager
    EOF
  }
}

# Runtime properties for each service
resource "kubernetes_config_map" "druid_coordinator" {
  metadata {
    name      = "druid-coordinator-config"
    namespace = kubernetes_namespace.flipflow.metadata[0].name
  }

  data = {
    "runtime.properties" = <<-EOF
      druid.service=druid/coordinator
      druid.plaintextPort=8081

      # HTTP server
      druid.server.http.numThreads=25
      druid.coordinator.startDelay=PT30S
      druid.coordinator.period=PT30S
    EOF
    "jvm.config"         = <<-EOF
      -server
      -Xms1g
      -Xmx1g
      -XX:+UseG1GC
      -XX:+ExitOnOutOfMemoryError
      -Duser.timezone=UTC
      -Dfile.encoding=UTF-8
      -Djava.io.tmpdir=var/tmp
      -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager
    EOF
  }
}

resource "kubernetes_config_map" "druid_broker" {
  metadata {
    name      = "druid-broker-config"
    namespace = kubernetes_namespace.flipflow.metadata[0].name
  }

  data = {
    "runtime.properties" = <<-EOF
      druid.service=druid/broker
      druid.plaintextPort=8082

      # HTTP server
      druid.server.http.numThreads=25
      druid.processing.buffer.sizeBytes=67108864
      druid.processing.numMergeBuffers=2
      druid.processing.numThreads=2
      druid.broker.http.numConnections=5
      druid.broker.http.compressionCodec=gzip
    EOF
    "jvm.config"         = <<-EOF
      -server
      -Xms1g
      -Xmx1g
      -XX:+UseG1GC
      -XX:+ExitOnOutOfMemoryError
      -Duser.timezone=UTC
      -Dfile.encoding=UTF-8
      -Djava.io.tmpdir=var/tmp
      -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager
      -XX:MaxDirectMemorySize=400m
    EOF
  }
}

resource "kubernetes_config_map" "druid_historical" {
  metadata {
    name      = "druid-historical-config"
    namespace = kubernetes_namespace.flipflow.metadata[0].name
  }

  data = {
    "runtime.properties" = <<-EOF
      druid.service=druid/historical
      druid.plaintextPort=8083

      # HTTP server
      druid.server.http.numThreads=25
      druid.processing.buffer.sizeBytes=67108864
      druid.processing.numMergeBuffers=2
      druid.processing.numThreads=2
      druid.segmentCache.locations=[{"path":"/opt/shared/segment-cache","maxSize":"300m"}]
      druid.server.maxSize=300m
    EOF
    "jvm.config"         = <<-EOF
      -server
      -Xms1g
      -Xmx1g
      -XX:+UseG1GC
      -XX:+ExitOnOutOfMemoryError
      -Duser.timezone=UTC
      -Dfile.encoding=UTF-8
      -Djava.io.tmpdir=var/tmp
      -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager
      -XX:MaxDirectMemorySize=400m
    EOF
  }
}

resource "kubernetes_config_map" "druid_middlemanager" {
  metadata {
    name      = "druid-middlemanager-config"
    namespace = kubernetes_namespace.flipflow.metadata[0].name
  }

  data = {
    "runtime.properties" = <<-EOF
      druid.service=druid/middleManager
      druid.plaintextPort=8091

      # HTTP server
      druid.server.http.numThreads=25
      druid.worker.capacity=2
      druid.indexer.runner.javaOptsArray=["-server", "-Xmx1g", "-XX:+UseG1GC", "-XX:+ExitOnOutOfMemoryError", "-Duser.timezone=UTC", "-Dfile.encoding=UTF-8", "-Djava.io.tmpdir=var/tmp", "-XX:+HeapDumpOnOutOfMemoryError", "-XX:HeapDumpPath=var/tmp"]
      druid.indexer.task.baseTaskDir=/opt/shared/task
      druid.indexer.task.gracefulShutdownTimeout=PT5M
      druid.indexer.task.hadoopWorkingPath=var/druid/hadoop-tmp
      druid.indexer.task.defaultHadoopCoordinates=["org.apache.hadoop:hadoop-client:2.8.5"]
    EOF
    "jvm.config"         = <<-EOF
      -server
      -Xms1g
      -Xmx1g
      -XX:+UseG1GC
      -XX:+ExitOnOutOfMemoryError
      -Duser.timezone=UTC
      -Dfile.encoding=UTF-8
      -Djava.io.tmpdir=var/tmp
      -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager
    EOF
  }
}

resource "kubernetes_config_map" "druid_router" {
  metadata {
    name      = "druid-router-config"
    namespace = kubernetes_namespace.flipflow.metadata[0].name
  }

  data = {
    "runtime.properties" = <<-EOF
      druid.service=druid/router
      druid.plaintextPort=${var.druid_router_port}

      # HTTP server
      druid.server.http.numThreads=25
      druid.router.http.numConnections=20
      druid.router.http.readTimeout=PT5M
      druid.router.http.numMaxThreads=100
      druid.router.defaultBrokerServiceName=druid/broker
      druid.router.coordinatorServiceName=druid/coordinator

      # Management proxy to coordinator / overlord: required for access to the web console
      druid.router.managementProxy.enabled=true
    EOF
    "jvm.config"         = <<-EOF
      -server
      -Xms512m
      -Xmx512m
      -XX:+UseG1GC
      -XX:+ExitOnOutOfMemoryError
      -Duser.timezone=UTC
      -Dfile.encoding=UTF-8
      -Djava.io.tmpdir=var/tmp
      -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager
    EOF
  }
}