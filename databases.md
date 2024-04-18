# DataBase

## TimeStamp Algorithom

- a transaction T with timestamp ts(T)
- read_timestamp = max((ts(T), read_timestamp(x))

| 场景            | BTO               | Thomas                    |
| --------------- | ----------------- | ------------------------- |
| Read + read     | Yes yes           | Yes yes                   |
| Read then write | Write: no         | Write: no                 |
| Write then read | Read: no          | Read: no, ,last roll back |
| Write + write   | 1 roll back, 2 no | 1 yes, 2 no               |



### Basic Timestamp Ordering Algorithom (BTO)

### Thomas Write Rule



## Graph

- Each transaction is a vertex

### Precedence Graph (Arcs from T1 to T2):

1. T1 read x then T2 writes x
2. T1 writes x then T2 reads x
3. T1 writes x then T2 writes x



### Wait for Graph (Arcs from T2 to T1):

1. T1 read-locks x then T2 tries to write-lock x
2. T1 write-locks x then T2 tries to read-lock x
3. T1 write-locks x then T2 tries to write-lock x









