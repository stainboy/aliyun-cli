# 阿里云命令行工具 (Aliyun Command Line Interface)

阿里云命令行工具（Alibaba Cloud Command Line Interface）是开源项目，您可以从[Github](https://github.com/aliyun/aliyun-cli)上获取最新版本的CLI。

该版本的CLI为Go语言重构版本，目前处于**BETA**发布中，如果您想使用原有的Python版本，请切换到[Python分支](https://github.com/aliyun/aliyun-cli/tree/python_final)。

## 简介

阿里云命令行工具是用Go语言编写的, 基于阿里云OpenAPI打造的，用于管理阿里云资源的工具。通过下载和配置该工具，您可以在一个命令行方式下使用多个阿里云产品。

欢迎通过提交[Github Issue](https://github.com/aliyun/aliyun-cli/issues/new)与我们沟通。建议您加入阿里云官方SDK&CLI客户服务群，钉钉群号：11771185。

**注意**：阿里云CLI使用OpenAPI方式访问云产品，确保您已经开通了要使用的云产品并了解该产品的OpenAPI的使用。您可以在[阿里云API平台](https://developer.aliyun.com/api)获取产品API文档，了解API的使用方式及参数列表。


## 安装阿里云CLI

您可以通过下载安装包或者直接编译源码的方式安装阿里云CLI：

- **下载安装包**

	阿里云CLI工具下载、解压后即可使用，支持Mac, Linux, Windows平台(x64版本)。	您可以将解压的`aliyun`可执行文件移至`/usr/local/bin`目录下，或添加到`$PATH`中。

	下载链接如下 (0.80 Beta)：

	- [Mac](http://aliyun-cli.oss-cn-hangzhou.aliyuncs.com/aliyun-cli-macosx-0.70-amd64.tgz)
	- [Linux](http://aliyun-cli.oss-cn-hangzhou.aliyuncs.com/aliyun-cli-linux-0.70-amd64.tgz)
	- [Windows (64 bit)](http://aliyun-cli.oss-cn-hangzhou.aliyuncs.com/aliyun-cli-windows-0.70-amd64.zip)

    下载链接如下: (0.70 Beta)

	- [Mac](http://aliyun-cli.oss-cn-hangzhou.aliyuncs.com/aliyun-cli-macosx-0.60-amd64.tgz)
	- [Linux](http://aliyun-cli.oss-cn-hangzhou.aliyuncs.com/aliyun-cli-linux-0.60-amd64.tgz)
	- [Windows (64 bit)](http://aliyun-cli.oss-cn-hangzhou.aliyuncs.com/aliyun-cli-windows-0.60-amd64.zip)

- **编译源码**

	请先安装并配置好Golang环境，并按照如下步骤下载源码并编译。

	```
	$ mkdir -p $GOPATH/src/github.com/aliyun
	$ cd $GOPATH/src/github.com/aliyun
	$ git clone http://github.com/aliyun/aliyun-cli.git
	$ git clone http://github.com/aliyun/aliyun-openapi-meta.git
	$ cd aliyun-cli
	$ make install
	```

## 配置阿里云CLI

在使用阿里云CLI前，您需要运行`aliyun configure`命令进行配置。在配置阿里云CLI时，您需要提供阿里云账号以及一对AccessKeyId和AccessKeySecret。

您可以在阿里云控制台的[AccessKey页面](https://ak-console.aliyun.com/#/accesskey)创建和查看您的AccessKey，或者联系您的系统管理员获取AccessKey。

#### 基本配置

```
$ aliyun configure
Configuring profile 'default' ...
Aliyun Access Key ID [None]: <Your AccessKey ID>
Aliyun Access Key Secret [None]: <Your AccessKey Secret>
Default Region Id [None]: cn-hangzhou
Default output format [json]: json
Default Languate [zh]: zh
```

#### 多用户配置

阿里云CLI支持多用户配置。您可以使用`$ aliyun configure --profile user1`命令指定使用哪个账号调用OpenAPI。

执行`$ aliyun configure list`命令可以查看当前的用户配置, 如下表。 其中在Profile后面有星号（*）标志的为当前使用的默认用户配置。

```
Profile   | Credential         | Valid   | Region           | Language
--------- | ------------------ | ------- | ---------------- | --------
default * | AK:***f9b          | Valid   | cn-beijing       | zh
aaa       | AK:******          | Invalid |                  |
test      | AK:***456          | Valid   |                  | en
ecs       | EcsRamRole:EcsTest | Valid   | cn-beijing       | en
```

#### 其他认证方式

阿里云CLI，可通过在`configure`命令后增加`--mode <authenticationMethod>`参数的方式来使用不同的认证方式，目前支持的认证方式如下：

| 验证方式  | 说明 |
| --------       | -------- |
| AK             | 使用AccessKey ID/Secret访问 |
| StsToken       | 使用STS Token访问    |
| RamRoleArn     | 使用RAM子账号的AssumeRole方式访问     |
| EcsRamRole     | 在ECS实例上通过EcsRamRole实现免密验证   |

#### 启用zsh/bash自动补全

- 使用`aliyun auto-completion`命令开启自动补全，目前支持zsh/bash
- 使用`aliyun auto-completion --uninstall`命令关闭自动补全

## 使用阿里云CLI

阿里云云产品的OpenAPI有RPC和RESTful两种风格，大部分产品使用的是RPC风格。不同风格的API的调用方法也不同。

您可以通过以下特点判断API风格：

- API参数中包含`Action`字段的是RPC风格，需要`PathPattern`参数的是Restful风格。
- 一般情况下，每个产品内，所有API的调用风格是统一的。
- 每个API仅支持特定的一种风格，传入错误的标识，可能会调用到其他API，或收到“ApiNotFound”的错误信息。

####调用RPC风格的API

阿里云CLI中RPC风格的API调用的基本结构如下：

```
$ aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]
```

代码示例：

```
$ aliyun rds DescribeDBInstances --PageSize 50
$ aliyun ecs DescribeRegions
$ aliyun rds DescribeDBInstanceAttribute --DBInstanceId xxxxxx
```


#### 调用RESTful风格的API

部分阿里云产品如容器服务的OpenAPI为Restful风格，调用Restful风格的接口与调用RPC风格的接口方式不同。参考以下代码示例，调用RESTful API。

- GET请求示例：

	```
	$ aliyun cs GET /clusters
	```

- POST请求示例：

	```
	$ aliyun cs POST /clusters --body "$(cat input.json)"
	```

- DELETE请求示例：

	```
	$ aliyun cs DELETE /clusters/ce2cdc26227e09c864d0ca0b2d5671a07
	```

#### 获取帮助信息

阿里云CLI集成了一部分产品的API和参数列表信息, 您可以使用如下命令来获取帮助：

- `$ aliyun help`: 获取产品列表

- `$ aliyun help <product>`: 获取产品的API信息

	如获取ECS的API信息：`$ aliyun help ecs`

- `$ aliyun help <product> <apiName>`: 获取API的调用信息

	如获取ECS的CreateInstance的信息： `aliyun help ecs CreateInstance`

#### 使用`--force`参数

阿里云CLI集成了一部分云产品的元数据，在调用时会对参数的合法性进行检查。如果使用了一个元数据中未包含的API或参数会导致`unknown api`或`unknown parameter`错误。可以使用`--force`参数跳过API和参数检查，强制调用元数据列表外的API和参数，如:

```
$ aliyun newproduct --version 2018-01-01 --endpoint newproduct.aliyuncs.com --param1 ... --force
```

在使用`--force`参数时，必须指定以下两个参数：

- `--version`: 指定API的版本，你可以在API文档中找到版本号，如ECS的版本号是`2014-05-26`。
- `--endpoint`: 指定产品的接入地址，一般产品接入地址是`product.aliyuncs.com`，或`product.en-central-1.aliyuncs.com`，请参考各产品的API文档。

- `--waiter timeout=xxx`：