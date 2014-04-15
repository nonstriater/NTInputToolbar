
# NTInputToolbar 

NTInputToolbar 是一个用于文字和表情输入的工具控件。拥有完美的高度自适应动画效果，且支持iOS7。默认的图片素材取自微信，你也可以自定义图片和背景颜色。


<img src="https://github.com/nonstriater/NTInputToolbar/raw/master/demo.jpg" alt="NTSlidingViewController Screenshot" width="320" height="568" />


## Requiredments

* ARC
* Xcode 5 or higher
* Apple LLVM compiler
* iOS 7.0、6.0



## TODO:

1. 待优化，facialview初始化优化
在主线程上实例化了近700个button，导致启动慢,内存飙升
  >引入延迟加载(lazy load)  
  >使用coregraphic画button控件

2. pagecontrol控件
3. 添加 voice button


## fix bug：

1. 在最大行时，resize properly




## LICENSE

NTInputToolbar is available under the MIT license.

Copyright © 2014 @Nonstriater.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
