# TCP (Transmission Control Protocol)

TCP 传输控制协议，提供的是面向连接，可靠的字节流服务，当客户端和服务器彼此交换数据前，必须先在双方之间建立一个TCP连接，之后才能传输数据。TCP提供超时重发，丢弃重复数据，检验数据，流量控制等功能，保证数据能从一端传到另一端。通俗说，它是事先为所发送的数据开辟出连接好的通道，然后再进行数据发送；


# UDP (User Datagram Protocol) 

UDP 是一个简单的面向非连接的用户数据报协议。UDP 不提供可靠性数据传输。


## TCP 和 UDP 的区别
1 > 连接方式  
* TCP 三次握手建立连接。
* UDP 封装成数据包，UDP数据包括目的端口号和源端口号信息。

2 > 数据传输大小 
* TCP 通道已经建立，数据大小不受限制
* UDP 每个数据报大小限制在64k 之内

3 > 安全性 
* TCP 通过三次握手完成连接，可靠的协议，安全送达。
* UDP 无需连接，不可靠的协议。

4> 效率性
* TCP 必须建立连接，效率会低一点
* UDP 不需要建立连接，速度快.


# 三次握手 （建立连接）
[百度百科](https://baike.baidu.com/item/%E4%B8%89%E6%AC%A1%E6%8F%A1%E6%89%8B/5111559?fr=aladdin)   

ACK：确认标志 确认编号（Acknowledgement Number）  

SYN：同步标志 同步序列编号（Synchronize Sequence Numbers） 

FIN：结束标志  


![1](https://github.com/AlexanderYeah/ATKeepStudyWorkSpace/blob/master/img_source/tcp_handshake.png)


* 第一次握手： 建立连接。客户端发送连接请求报文段，客户打算连接的服务器的端口，将SYN 位置为1，Seq 为 X，客户端进入到SYN_SEND 状态，等待服务器的确认。

* 第二次握手：服务器收到SYN 报文段，服务器收到客户端的SYN报文段，需要对这个SYN 报文段进行确认。设置ACK 为 X+1 (就是客户端的Seq + 1),表示收到了客户端的请求。同时还要发送自己的SYN 请求吧信息，SYN 位置为1，Seq 为 y；服务器将所有信息放到一个报文段（SYN+ACK）报文段中，一并发送给客户端，此时服务器进入到SYN_RECV 状态。

* 第三次握手: 客户端收到服务器的SYN + ACK 报文段之后，将后将ACK 设置成y+1（就是服务端的seq+1），表示收到了服务端的信息。然后发送ACK 报文段给服务器。发送完毕，客户端和服务端都进入ESTABLISHED 状态，完成TCP 三次握手。







 # 四次握手 （断开连接）
 
* 第一次挥手：主机1（可以使客户端，也可以是服务器端），设置Sequence Number和Acknowledgment Number，向主机2发送一个FIN报文段；此时，主机1进入FIN_WAIT_1状态；这表示主机1没有数据要发送给主机2了；

* 第二次挥手：主机2收到了主机1发送的FIN报文段，向主机1回一个ACK报文段，Acknowledgment Number为Sequence Number加1；主机1进入FIN_WAIT_2状态；主机2告诉主机1，我“同意”你的关闭请求； 
 
* 第三次挥手：主机2向主机1发送FIN报文段，请求关闭连接，同时主机2进入LAST_ACK状态；  

* 第四次挥手：主机1收到主机2发送的FIN报文段，向主机2发送ACK报文段，然后主机1进入TIME_WAIT状态；主机2收到主机1的ACK报文段以后，就关闭连接；此时，主机1等待2MSL后依然没有收到回复，则证明Server端已正常关闭，那好，主机1也可以关闭连接了。
