<!-- markdownlint-disable no-duplicate-header -->

# 模块

hippy-vue 通过在 Vue 上绑定了一个 `Native` 属性，实现获取终端设备信息、以及调用终端模块。也可以用来监测是否在 Hippy 环境下运行。

> 对应 Demo: [demo-vue-native.vue](//github.com/Tencent/Hippy/blob/master/examples/hippy-vue-demo/src/components/native-demos/demo-vue-native.vue)

---

# 获取终端信息

它无需任何方法，直接取值即可。

## version

获取 hippy-vue 的版本

* 示例

```javascript
console.log(Vue.Native.version); // => 2.0.0
```

## Device

获取设备名称，iPhone 可以拿到具体的 iPhone 型号，Android 设备暂时只能拿到 `Android device`的文本。

## OSVersion

iOS 版本。

## APILevel

Android 操作系统版本。

## SDKVersion

Hippy 终端 SDK 版本。

## Platform

获取操作系统类型。

* 示例

```javascript
console.log(Vue.Native.Platform); // => android
```

## Dimensions

获取屏幕分辨率。

* 示例

```javascript
const { window, screen } = Vue.Native.Dimensions;
console.log(`屏幕尺寸：${screen.height}x${screen.width}`); // => 640x480
console.log(`带状态栏的窗口尺寸：${window.height}x${window.width}`); // => 640x460
```

## PixelRatio

获取设备像素比例。

* 示例

```javascript
console.log(Vue.Native.PixelRatio); // => 3
```

## isIPhoneX

获取是否是异形屏幕的 iPhoneX。

## screenIsVertical

屏幕是否切换成横屏。

## OnePixel

一个像素的 dp/pt 值。

## Localization

>* 最低支持版本 2.8.0

输出国际化相关信息，`object: { country: string , language: string, direction: number }`， 其中 `direction` 为 0 表示 LTR 方向，1 表示 RTL 方向

---

# AsyncStorage

>* 最低支持版本 2.7.0
>* AsyncStorage 能力与挂载在全局变量下的 localStorage 模块一致，localStorage 可以在所有版本使用

[[AsyncStorage 范例（与Hippy-React AsyncStorage 一致）]](//github.com/Tencent/Hippy/tree/master/examples/hippy-react-demo/src/modules/AsyncStorage/index.jsx)

AsyncStorage 是一个简单的、异步的、持久化的 Key-Value 存储系统。

* 示例：

``` js
Vue.Native.AsyncStorage.setItem('itemKey', 'itemValue');
Vue.Native.AsyncStorage.getItem('itemKey');
```

## 方法

### AsyncStorage.getAllKeys

`() => Promise<string[]>` 获取 AsyncStorage 所有的key。

### AsyncStorage.getItem

`(key: string) => Promise<string>` 根据 key 值获取对应数据。

> * key: string - 需要获取值的目标 key

### AsyncStorage.multiGet

`(key: string[]) => Promise<[key: string, value: string][]>` 一次性用多个 key 值的数组去批量请求缓存数据，返回值将在回调函数以键值对的二维数组形式返回。

> * key: string[] - 需要获取值的目标 key 数组

### AsyncStorage.multiRemove

`(key: string[]) => void` 调用此函数批量删除 AsyncStorage 里面在传入的 keys 数组存在的 key 值。

> * key: string[] - 需要删除的目标 key 数组

### AsyncStorage.multiSet

`(keyValuePairs: [key: string, value: string][]) => void` 调用这个函数可以批量存储键值对对象。

> * keyValuePairs: [key: string, value: string][] - 需要设置的储键值二维数组

### AsyncStorage.removeItem

`(key: string) => void` 根据 key 值删除对应数据。

> * key: string - 需要删除的目标 key

### AsyncStorage.setItem

`(key: string, value: string) => void` 根据 key 和 value 设置保存键值对。

> * key: string - 需要获取值的目标 key
> * value: string - 需要获取值的目标值

---

# BackAndroid

[[BackAndroid 范例]](//github.com/Tencent/Hippy/blob/master/examples/hippy-vue-demo/src/main-native.js)

可以监听 Android 实体键的回退，在退出前做操作或拦截实体键的回退。

>* 最低支持版本 2.7.0
>* 注意：该方法需要终端拦截实体返回按钮的事件，可以参考 [android-demo 的 onBackPressed 方法](//github.com/Tencent/Hippy/blob/v3.0-dev/framework/examples/android-demo/src/main/java/com/openhippy/example/PageConfiguration.kt)

## 方法

### BackAndroid.addListener

`(handler: () => boolean) => { remove: Function }` 监听Android实体健回退，触发时执行 handler 回调函数。回调函数返回 true 时，拦截终端的回退操作；回调函数返回 false 时, 就不会拦截回退。该方法会返回包含 `remove()` 方法的对象，可通过调用 `remove()` 方法移除监听，同 `BackAndroid.removeListener`。

> * handler: Function - 实体键回退时触发的回调函数

### BackAndroid.exitApp

`() => void`直接执行终端的退出 App 逻辑。

### BackAndroid.removeListener

`(handler: () => boolean) => void` 移除 BackAndroid 关于Android实体健回退事件的监听器。

* handler: Function - 建议使用 `addListener` 返回的包含 `remove()` 方法的对象，也可以是之前 BackAndroid 的回调函数。

---

# callNative/callNativeWithPromise

调用终端模块的方法，`callNative` 一般用于无返回的模块方法调用，`callNativeWithPromise` 一般用于有返回的模块方法调用，它会返回一个带着结果的 Promise。

# callUIFunction

调用组件定义的终端方法

`callUIFunction(instance: ref, method: string, options: Array)`

> * instance: 组件的引用 Ref
> * method：方法名称，如 ListView 的 `scrollToIndex`
> * options: 需传递的数据，如 ListView 的 `[xIndex, yIndex, animated]`

注: 也可以传入 callback 参数，这个是 Hippy 内部 API, 不推荐使用，源码可参考：

[callUIFunction接口实现源码](https://github.com/Tencent/Hippy/blob/main/driver/js/packages/hippy-vue/src/runtime/native.ts)

---

# Clipboard

剪贴板读写模块，但是目前只支持纯文本。

## 方法

### getString()

返回值：

* string

### setString(content)

| 参数 | 类型     | 必需 | 参数意义 |
| --------  | -------- | -------- |  -------- |
| content | string | 是       | 保存进入剪贴板的内容 |

---

# ConsoleModule

> 最低支持版本 2.10.0

提供了将前端日志输出到 iOS 终端日志和 [Android logcat](//developer.android.com/studio/command-line/logcat) 的能力

## 方法

### ConsoleModule.log

`(...value: string) => void`

### ConsoleModule.info

`(...value: string) => void`

### ConsoleModule.warn

`(...value: string) => void`

### ConsoleModule.error

`(...value: string) => void`

> * `log` 和 `info` 默认都输出为终端 INFO 级别日志
> * Hippy 2.10.0 版本之后将原始 js 的 `console` 方法与 `ConsoleModule` 方法进行分离，`console` 不再输出日志到终端

---

# Cookie

Hippy 中通过 fetch 服务返回的 `set-cookie` Header 会自动将 Cookie 保存起来，下次再发出请求的时候就会带上，业务可以获取或者修改保存好的 Cookie。

## 方法

### getAll(url)

| 参数 | 类型     | 必需 | 参数意义 |
| --------  | -------- | -------- |  -------- |
| url | string | 是       | 获取指定 url 下的所有 cookies，`2.14.0` 版本后过期的 Cookies 将不再返回。 |

返回值：

* `Prmoise<string>`，获取到诸如 `name=hippy;network=mobile` 的字符串。

### set(url, keyValue, expireDate)

参数：

| 参数 | 类型     | 必需 | 参数意义 |
| -------- | -------- | -------- |  -------- |
| url | string | 是   | 设置指定 URL 下设置的 cookie |
| keyValue | string | 是   | 需要设置成 cookie 的完整字符串，例如 `name=hippy;network=mobile`，`2.14.0` 版本后设置 `空字符串` 会强制清除（过期）指定域名下的所有 Cookies |
| expireDate | Date | 否 | Date 类型的过期时间，不填不过期, 内部会通过 `toUTCString` 转成 `String` 传给客户端 |

---

# getElemCss

获取具体节点的 CSS 样式。

> 最低支持版本 `2.10.1`

`(ref: ElementNode) => {}`

* 示例：

```js
this.demon1Point = this.$refs['demo-1-point'];
console.log(Vue.Native.getElemCss(this.demon1Point)) // => { height: 80, left: 0, position: "absolute" }
```

---

# ImageLoader

通过该模块可以对远程图片进行相应操作

> 最低支持版本 `2.7.0`

## 方法

### ImageLoader.getSize

`(url: string) => Promise<{width, height}>` 获取图片大小（会同时预加载图片）。

> * url - 图片地址

### ImageLoader.prefetch

`(url: string) => void` 用于预加载图片。

> * url - 图片地址

---

# measureInAppWindow

> 最低支持版本 `2.11.0`

测量在 App 窗口范围内某个组件的尺寸和位置，注意需要保证节点实例真正上屏后（layout事件后）才能调用该方法。

`(ref) => Promise<{top: number, left: number, right: number, bottom: number, width: number, height: number}>`

> * Promise resolve 的参数可以获取到引用组件在 App 窗口范围内的坐标值和宽高，如果出错或 [节点被优化（仅在Android）](api/style/layout?id=collapsable) 会返回 { top: -1, left: -1, right: -1, bottom: -1, width: -1, height: -1 }

---

# getBoundingClientRect

> 最低支持版本 `2.15.3`，原有 `measureInWindow` 和 `measureInAppWindow` 将逐渐废弃

测量元素在宿主容器（RootView）或者 App 窗口（屏幕）范围内的尺寸和位置。

`(instance: ref, options: { relToContainer: boolean }) => Promise<DOMRect: { x: number, y: number, width: number, height: number, bottom: number, right: number, left: number, top: number }>`

> * instance: 元素或组件的引用 Ref。
> * options: 可选参数，`relToContainer` 表示是否相对宿主容器（RootView）进行测量，默认 `false` 相对 App 窗口或屏幕进行测量。当对宿主容器（RootView）进行测量时，`iOS` 包含顶部状态栏高度，`Android` 不包含。
> * DOMRect: 与 [MDN](https://developer.mozilla.org/zh-CN/docs/Web/API/Element/getBoundingClientRect) 一致的返回参数, 可以获取元素相应的位置信息和尺寸，如果出错或者 [节点被优化（仅在Android）](api/style/layout?id=collapsable)，会触发 `Promise.reject`。

---

# NetInfo

通过该接口可以获得当前设备的网络状态；也可以注册一个监听器，当系统网络切换的时候，得到网络变化通知。

> 最低支持版本 `2.7.0`

安卓的开发者，在请求网络状态之前，你需要在app的 `AndroidManifest.xml` 加入以下配置 :

```xml
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

## 网络状态

以异步的方式判断设备是否联网，以及是否使用了移动数据网络。

* `NONE` -  设备处于离线状态。
* `WIFI` - 设备通过wifi联网
* `CELL` - 设备通过移动网络联网
* `UNKNOWN` - 出现异常或联网状态不可知

## 方法

### NetInfo.addEventListener

`(eventName: string, handler: Function) => NetInfoRevoker` 添加一个网络变化监听器。

> * eventName: 'change' - 事件名称
> * handler: ({ network_info:string }) => any - 网络发生变化时触发的回调函数

### NetInfo.fetch

`() => Promise<NetInfo>` 用于获取当前的网络状态。

### NetInfo.removeEventListener

`(eventName: string, handler: NetInfoRevoker | Function) => void` 移除事件监听器

> * eventName: 'change' - 事件名称
> * handler: Function - 需要删除的对应事件监听。

---

# parseColor

色值类型转换，通过该 API 获取终端可识别的 `int32` 类型色值。可应用于与终端直接通讯（如 `callNative`) 时的接口传参。

| 参数 | 类型     | 必需 | 参数意义 |
| --------  | -------- | -------- |  -------- |
| color | `string` `number` | 是  | 转换的色值，支持类型：`rgb`,`rgba`, `hex` |

返回值：

* `number`: 返回值为终端可识别的 `int32Color`

* 示例：

``` js
const int32Color = Vue.Native.parseColor('#40b883') // int32Color: 4282431619
```
