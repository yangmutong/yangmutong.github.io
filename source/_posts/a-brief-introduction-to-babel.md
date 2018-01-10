---
title: babel学习（1）
date: 2018-01-08 13:09:09
tags:
---
### Babel介绍

`Babel`通过语法转换器转换新的ES语法。目前的babel包括很多功能，最基础的转换语法，增加polyfill，支持DSL，例如JSX，FLOW。同时可插拔的设计，能够将babel应用到项目打包构建的任一环节中。

目前最新版`Babel`为`Babel 6`, 根据消息，`Babel 7`也将于近期发布。新版`Babel`对于配置简化了很多，建议使用最新版`Babel`

<!--more-->

推荐使用`Babel`[官网](https://babeljs.io)或者[handbook](https://github.com/thejameskyle/babel-handbook/blob/master/translations/zh-Hans/user-handbook.md)

文档质量不错，可以通过查看文档来学习如何使用`Babel`。

`Babel`工作流程分为三个阶段:
parse 解析 => transform, 转换 => generate, 生成。
解析阶段是解析开发者编写的JS代码，这部分开发者无法影响，涉及到编译原理的词法分析 -> 语法分析 -> 生成语法树 -> 生成抽象语法树这些阶段。针对生成的语法树，会进行转换，开发者可以使用babel提供的plugin和preset来影响这一阶段，在此阶段可以进行任何事情的操作。生成阶段根据第二阶段的结果来产出代码。

以上所描述的均是针对语法，只能够针对语法进行转译。而对于APIs，语法上的转译并不生效，需要使用polyfill，polyfill原理与上述不同，babel主要使用`corejs`来进行polyfill，想要了解详情，需要查看`corejs`相关文档和代码。

就目前的前端开发环境来说，不会单独使用`Babel`，而是将其作为项目打包构建的某个环节之一。所以对于使用者来说，最重要的是如何将`Babel`集成进入项目的构建流程中，对于`Babel`提供的命令行工具`babel-registry`或者`babel-core`等来说，不会直接使用它，而是使用插件，由插件来配置并调用这些工具。

`Babel`社区有着良好的生态，插件很丰富，目前来说，`Babel`主要有两种方式来配置使用，一个是plugin，一个是preset，preset是一系列的插件的集合，遵循预制的特定方式来处理js文件。

### 配置文件

`.babelrc`文件可以配置你想要`Babel`需要做的事情，一般内容为下

```json
{
    "preset": [],
    "plugin": []
}
```

分别放置`preset`和`plugin`列表。目前preset或plugin均有很多npm包存在，发布者主要是`Babel`官方和一些第三方开发者。npm名存在一些规则, `babel-preset-`开头的均为preset，`babel-plugin-`开头的均为plugin。将前缀后的字符串填入上述配置文件的列表中即可使用该plugin或preset。

#### 常用的preset

* `env`: 官方的preset包，包含了最新的stage-4的ES标准，即相当于 es2015 ，es2016 ，es2017 及最新版本。

* `latest`: 最新版本，不建议使用，建议直接使用`env`

* `babel-preset-es2015/es-2016/es-2017`，常用于将ES2015/2016/2017的语法转换成ES5。

* `babel-preset-react`, 用于设置react

* `babel-preset-stage-x`, 首先介绍一个概念，目前ECMAScript技术委员会TC39将ES的一些提案分为几个阶段。
    
    * stage-0: strawman, 一种推进ECMAScript发展的自由形式，任何TC39成员，或者注册为TC39贡献者的会员，都可以提交。
    * stage-1: proposal, 该阶段产生一个正式的提案。
        1. 确定一个带头人来负责该提案，带头人或者联合带头人必须是TC39的成员。
        2. 描述清楚要解决的问题，解决方案中必须包含例子，API以及关于相关的语义和算法。
        3. 潜在问题也应该指出来，例如与其他特性的关系，实现它所面临的挑战。
        4. polyfill和demo也是必要的。
    * stage-2: draft, 草案是规范的第一个版本，与最终标准中包含的特性不会有太大差别。草案之后，原则上只接受增量修改。
    * stage-3: candidate, 候选阶段，获得具体实现和用户的反馈。此后，只有在实现和使用过程中出现了重大问题才会修改。
        1. 规范文档必须是完整的，评审人和ECMAScript的编辑要在规范上签字。
        2. 至少要有两个符合规范的具体实现。
    * stage-4: finished, 已经准备就绪，该特性会出现在年度发布的规范之中。
        1. 通过Test 262的验收测试。
        2. 有2个通过测试的实现，以获取使用过程中的重要实践经验。
        3. ECMAScript的编辑必须规范上的签字。

`Babel`对应这些stage分别有对应的preset。除了stage-4，因为stage-4已经是finished阶段了，所以没有stage,直接使用对应的最新的preset即可，例如`babel-preset-es2015`。

每种`babel-preset-stage-x`都依赖于紧随的后期阶段预设。例如，babel-preset-stage-1 依赖 babel-preset-stage-2，后者又依赖 babel-preset-stage-3。所以只需要使用想要使用的stage即可，不需要多余的安装。对于生产环境来说，建议最低使用到stage-3。不建议使用stage-2及以下的stage。

#### 常用的plugin

##### 转译plugin

转译plugin用于转译代码，preset不过是plugin的合集。转译plugin将启用相应的语法plugin，不需要同时使用。

##### 混合plugin

external-helpers，暂不需要关注

##### 语法plugin

允许`Babel`解析特定类型的语法，但是不进行转译，一般来说，这里主要针对DSL来配置语法plugin，例如JSX，flow

```json
{
  "parserOpts": {
    "plugins": ["jsx", "flow"]
  }
}
```

#### Plugin/Preset排序问题

plugin和preset都有一个排序的问题，babel在访问统一代码节点时，同时生效的plugin或preset需要安装规则来排序，然后再去执行

1. Plugin会运行在Preset之前
2. Plugin顺序执行，Preset逆序执行

#### Plugin/Preset选项问题

可以给Plugin/Preset传入选项，选项选择需要参考插件的文档说明，示例如下：

```json
{
    "plugin": [
        ["transform-runtime", {
            "loose": true
        }]
    ]
}
```

### .babelrc

1. 直接编写`.babelrc`文件，文件为JSON形式。
2. `package.json`中的babel选项也可以进行配置

在`Babel`进行转录时，会在当前目录查找`.babelrc`，如果不存在，则遍历整个目录，知道找到该文件或者发现`package.json`中的`babel`选项。

`Babel`也可以根据环境来配置不同的选项。目前前端开发，可以大致分为开发环境，联调测试环境，生产环境。对于`Babel`来说，基本上只需要区分开发联调测试和生产环境。可以通过配置文件的`env`选项来区分。

```json
{
    "env": {
        "production": {
            "plugin": []
        },
        "development": {
            "plugin": []
        }
    }
}
```

`Babel`会从`process.env.BABEL_ENV`中取值`env`。如果没有，则获取`process.env.NODE_ENV`的值。如果都无法获取，则默认值为`development`。所以编译时需要先设置环境变量。

### transform-runtime

`Babel`实际上只是负责语法上的转译，对于一些全局变量，APIs是不支持转译的，这些新的特性，例如Promise，是需要polyfill来支持的。所以`Babel`官方推出了`babel-polyfill`npm包，使用时需要将这个包安装为`dependency`而不是`devDependency`。并且需要在项目文件中明确引入这个包。

使用`babel-polyfill`较为麻烦，所以比较流行的是使用`babel-runtime`。polyfill是针对全局环境的，其实和`Babel`的语法解析，转译阶段并无任何关系。`babel-runtime`是在`Babel`中单独的模块中引入需要的polyfill，而不是在全局引入。但是使用上需要在模块文件中明确的引入`babel-runtime`，所以也比较低效。

配置`Babel`的语法分析的能力，可以实现在转译时动态的插入需要的polyfill。有个对应的插件`babel-plugin-transform-runtime`可以实现所需要的功能。

### 配合其他工具

`Babel`一般作为构建流程中一个环节，所以需要结合其他工具来使用。`Babel`官网提供了一些构建工具的[示例](http://babeljs.io/docs/setup/)

1. `Babel`与`ESLint`的结合
`Babel`官方维护了一个名为`babel-eslint`的工具，安装npm包后。可以在项目根目录配置一个新文件`.eslint`, `parser`字段配置为`babel-eslint`。

```json
{
    "parser": "babel-eslint",
    "rules": {}
}
```