# FLInputStreamTest
后台文件 I/O


https://github.com/zhenyiyi/FLInputStreamTest.git

我们将一整个文件加载到了内存中。这种方式对于较小的文件没有问题，但是受限于 iOS 设备的内存容量，对于大文件来说的话就不那么友好了。
要解决这个问题，我们将构建一个类，它负责一行一行读取文件而不是一次将整个文件读入内存，另外要在后台队列处理文件，以保持应用相应用户的操作。

为了达到这个目的，我们使用能让我们异步处理文件的 NSInputStream 。
根据官方文档的描述：
https://developer.apple.com/library/ios/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/TechniquesforReadingandWritingCustomFiles/TechniquesforReadingandWritingCustomFiles.html
如果你总是需要从头到尾来读/写文件的话，streams 提供了一个简单的接口来异步完成这个操作

不管你是否使用 streams，大体上逐行读取一个文件的模式是这样的：

	1. 建立一个中间缓冲层以提供，当没有找到换行符号的时候可以向其中添加数据
	
	2. 从 stream 中读取一块数据
	
	3. 对于这块数据中发现的每一个换行符，取中间缓冲层，向其中添加数据，直到（并包括）这个换行符，并将其输出
	
	4. 将剩余的字节添加到中间缓冲层去
	
	5. 回到 2，直到 stream 关闭