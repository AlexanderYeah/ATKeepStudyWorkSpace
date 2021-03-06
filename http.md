# HTTP 协议和HTTPS 协议详解

## 1 （HTTP）超文本传输协议
属于应用层面向对象的协议，其简洁快速的方式，适用于分布式超媒体信息系统。

###出现的前提：

客户端该传如何的数据给服务器，服务器才能够看懂，因为服务端跟客户端是跨语言的。
服务器该返回什么样的数据给客户端，客户端才能看懂，两边要进行怎么样的数据传输，才能有效的沟通。

 
特点：   

* C/S 模式,
* 可以传输任意类型的数据，并且用content－Type进行标记
* 无连接:是指每次只处理一个请求，处理完客户端的请求后，并受到客户的响应后，立马断开链接.
* 无状态: HTTP协议是无状态协议。无状态是指协议对于事务处理没有记忆能力。缺少状态意味着如果后续处理需要前面的信息，则它必须重传，这样可能导致每次连接传送的数据量增大。另一方面，在服务器不需要先前信息时它的应答就较快。


## 2 HTTPS 

https协议需要到ca申请证书，一般免费证书很少，需要交费。
HTTPS协议是由SSL+HTTP协议构建的可进行加密传输、身份认证的网络协议 要比http协议安全 HTTPS解决的问题：  

1> 信任主机的问题。采用https 的server 必须从CA 申请一个用于证明服务器用途类型的证书。  
  
2> 通讯过程中的数据的泄密和被窜改。一般意义上的https， 就是 server 有一个证书，少许对客户端有要求的情况下，会要求客户端也必须有一个证书。


## SLL 
SSL(Secure Sockets Layer） 安全套接层。
SSL运行在TCP/IP层之上、应用层之下，为应用程序提供加密数据通道，它采用了RC4、MD5 以及RSA等加密算法，使用40 位的密钥，适用于商业信息的加密。



