## 嘉为蓝鲸clickhouse插件使用说明

## 使用说明

### 插件功能
通过Clickhouse提供的HTTP接口查询SQL转换为监控指标。


### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

clickhouse: `22`, `23`, `24`, `25`

**是否支持远程采集:**

是

### 参数说明


| **参数名**             | **含义**                                          | **是否必填** | **使用举例**              |
|---------------------|-------------------------------------------------|----------|-----------------------|
| --scrape_uri        | ClickHouse HTTP 接口地址，格式为 `http://<host>:<port>` | 是        | http://127.0.0.1:8123 |
| CLICKHOUSE_USER     | ClickHouse 用户名（环境变量），无需转义特殊字符                   | 是        | monitor               |
| CLICKHOUSE_PASSWORD | ClickHouse 密码（环境变量），无需转义特殊字符                    | 是        | password              |
| --clickhouse_only   | 仅采集 ClickHouse 指标（布尔开关参数）                       | 否        | --clickhouse_only     |
| --telemetry.address | Exporter 监听地址及端口，格式为 `<ip>:<port>`              | 否        | 127.0.0.1:9601        |

### 使用指引
**创建监控专用账户并授权**

创建监控账户（如 monitor）
```sql
CREATE USER monitor IDENTIFIED BY 'password';
```

授权监控账户访问系统表
```sql
GRANT SHOW, SELECT ON system.* TO monitor;
```

**注意**  
集群模式下，若只在一个节点上建立用户，探针填写clickhouse URL时要注意指定对应的节点，否则会报不存在该用户，因为ClickHouse的用户信息是分布式存储的。  

### 指标简介
| **指标ID**                                        | **指标中文名**         | **维度ID** | **维度含义** | **单位** |
|-------------------------------------------------|-------------------|----------|----------|--------|
| clickhouse_up                                   | 监控插件运行状态          | -        | -        | -      |
| clickhouse_uptime                               | ClickHouse服务已运行时间 | -        | -        | s      |
| clickhouse_filesystem_logs_path_available_bytes | 文件系统日志目录可用字节大小    | -        | -        | bytes  |
| clickhouse_filesystem_logs_path_total_bytes     | 文件系统日志目录总字节大小     | -        | -        | bytes  |
| clickhouse_filesystem_logs_path_used_bytes      | 文件系统日志目录使用字节大小    | -        | -        | bytes  |
| clickhouse_filesystem_main_path_available_bytes | 文件系统主目录可用字节大小     | -        | -        | bytes  |
| clickhouse_filesystem_main_path_total_bytes     | 文件系统主目录总字节大小      | -        | -        | bytes  |
| clickhouse_filesystem_main_path_used_bytes      | 文件系统主目录使用字节大小     | -        | -        | bytes  |
| clickhouse_global_thread                        | 全局线程数量            | -        | -        | -      |
| clickhouse_global_thread_active                 | 活跃全局线程数量          | -        | -        | -      |
| clickhouse_global_thread_scheduled              | 计划全局线程数量          | -        | -        | -      |
| clickhouse_local_thread                         | 本地线程数             | -        | -        | -      |
| clickhouse_http_rejected_connections            | HTTP拒绝连接数         | -        | -        | -      |
| clickhouse_kafka_assigned_partitions            | Kafka分配分区数量       | -        | -        | -      |
| clickhouse_kafka_consumers                      | Kafka消费者数         | -        | -        | -      |
| clickhouse_kafka_consumers_in_use               | 使用中的Kafka消费者数量    | -        | -        | -      |
| clickhouse_kafka_producers                      | Kafka生产者数量        | -        | -        | -      |
| clickhouse_kafka_writes                         | Kafka写入数量         | -        | -        | -      |
| clickhouse_write                                | 写入数量              | -        | -        | -      |
| clickhouse_load_average1                        | 系统1分钟平均负载         | -        | -        | -      |
| clickhouse_load_average15                       | 系统15分钟平均负载        | -        | -        | -      |
| clickhouse_load_average5                        | 系统5分钟平均负载         | -        | -        | -      |
| clickhouse_memory_resident                      | 常驻内存大小            | -        | -        | bytes  |
| clickhouse_memory_virtual                       | 虚拟内存大小            | -        | -        | bytes  |
| clickhouse_network_receive                      | 网络连接接收数量          | -        | -        | -      |
| clickhouse_network_send                         | 网络连接发送数量          | -        | -        | -      |
| clickhouse_number_of_databases                  | 数据库中的库总数          | -        | -        | -      |
| clickhouse_number_of_tables                     | 数据库中的表总数          | -        | -        | -      |
| clickhouse_number_of_tables_system              | 数据库中的系统表总数        | -        | -        | -      |
| clickhouse_query                                | 查询数量              | -        | -        | -      |
| clickhouse_query_thread                         | 查询线程数量            | -        | -        | -      |
| clickhouse_query_time_microseconds_total        | 查询累计时长            | -        | -        | μs     |
| clickhouse_query_total                          | 查询总数量             | -        | -        | -      |
| clickhouse_read                                 | 读取数量              | -        | -        | -      |
| clickhouse_replicated_send                      | 异步复制发送数量          | -        | -        | -      |
| clickhouse_seek_total                           | 查找总数量             | -        | -        | -      |
| clickhouse_select_queries_with_subqueries_total | 含子查询的选择查询总数       | -        | -        | -      |
| clickhouse_select_query_time_microseconds_total | 选择查询累计时长          | -        | -        | μs     |
| clickhouse_select_query_total                   | 选择查询总数量           | -        | -        | -      |
| clickhouse_selected_rows_total                  | 选择行总数             | -        | -        | -      |
| clickhouse_storage_buffer_bytes                 | 存储缓冲区容量           | -        | -        | -      |
| clickhouse_total_space_in_bytes                 | 总空间容量             | disk     | 磁盘       | bytes  |
| clickhouse_free_space_in_bytes                  | 可用空间容量            | disk     | 磁盘       | bytes  |
| clickhouse_zoo_keeper_request                   | ZooKeeper请求数量     | -        | -        | -      |
| clickhouse_zoo_keeper_session                   | ZooKeeper会话数量     | -        | -        | -      |
| clickhouse_zoo_keeper_transactions_total        | ZooKeeper事务总数量    | -        | -        | -      |
| clickhouse_open_file_for_read                   | 打开读取文件数量          | -        | -        | -      |
| clickhouse_open_file_for_write                  | 打开写入文件数量          | -        | -        | -      |
| clickhouse_dns_error_total                      | DNS错误总数量          | -        | -        | -      |
| clickhouse_file_open_total                      | 打开文件总数量           | -        | -        | -      |
| clickhouse_keeper_alive_connections             | Keeper活跃连接数量      | -        | -        | -      |
| clickhouse_exporter_scrape_failures_total       | 探针抓取失败数           | -        | -        | -      |

### 版本日志

#### weops_clickhouse_exporter 3.1.5

- weops调整

