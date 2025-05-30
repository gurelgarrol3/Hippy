/*
 * Tencent is pleased to support the open source community by making
 * Hippy available.
 *
 * Copyright (C) 2022 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { HippyViewEvent } from 'hippy'
import HippyRenderBaseView, {
  HippyObservedArray,
  HIPPY_COMPONENT_KEY_PREFIX
}  from 'hippy/src/main/ets/renderer_native/components/base/HippyRenderBaseView'
import { HippyCustomComponentView } from 'hippy/src/main/ets/renderer_native/components/custom/HippyCustomComponentView'
import { buildHippyRenderView } from 'hippy/src/main/ets/renderer_native/HippyRenderViewBuilder'
import { NativeRenderContext } from 'hippy/src/main/ets/renderer_native/NativeRenderContext'
import { HRPadding, HRRect } from 'hippy/src/main/ets/renderer_native/utils/HRTypes'
import { HippyAny, HippyRenderCallback } from 'hippy/src/main/ets/support/common/HippyTypes'
import { LogUtils } from 'hippy/src/main/ets/support/utils/LogUtils'

@Observed
export class ExampleViewA extends HippyCustomComponentView {
  constructor(ctx: NativeRenderContext) {
    super(ctx)
  }

  setProp(propKey: string, propValue: HippyAny): boolean {
    if (propKey == "prop1") {
      // ...
      return true
    } else if (propKey == "prop2") {
      // ...
      return true
    }
    return super.setProp(propKey, propValue)
  }

  call(method: string, params: Array<HippyAny>, callback: HippyRenderCallback | null): void {
    if (method == "selectItem") {
      // ...
    } else if (method == "getData") {
      // ...
      // 如果需要返回值，返回值举例
      if (callback) {
        callback("result")
      }
    }
  }
}

@Component
export struct ExampleComponentA {
  @ObjectLink renderView: ExampleViewA
  @ObjectLink children: HippyObservedArray<HippyRenderBaseView>

  aboutToAppear() {
    LogUtils.d('hippy demo', 'A to appear, tag: ' + this.renderView.tag)

    // 自定义事件举例
    let event = new HippyViewEvent("onEvent1")
    let params = new Map<string, string>()
    params.set('key1', 'value1')
    event.send(this.renderView.ctx, this.renderView.tag, params)
  }

  aboutToDisappear() {
    LogUtils.d('hippy demo', 'A to disappear, tag: ' + this.renderView.tag)
  }

  build() {
    Stack() {
      Text("This is a custom component A.")
      ForEach(this.children, (item: HippyRenderBaseView) => {
        buildHippyRenderView(item, null)
      }, (item: HippyRenderBaseView) => item.tag + '')
      // 该自定义组件有Hippy子组件或其它自定义子组件时，必须加Slot来衔接子组件
      ContentSlot(this.renderView.childSlot)
    }
    .applyRenderViewBaseAttr(this.renderView)
  }
}

// base props for all components
@Extend(Stack)
function applyRenderViewBaseAttr($$: HippyRenderBaseView) {
  .key(HIPPY_COMPONENT_KEY_PREFIX + $$.tag)
  .backgroundColor($$.cssBackgroundColor)
  .position({x: $$.cssPositionX, y: $$.cssPositionY})
  .size({width:$$.cssWidth, height: $$.cssHeight})
  .opacity($$.cssOpacity)
  .clip($$.cssOverflow)
  .visibility(($$ as HippyRenderBaseView).cssVisibility) // must add as, otherwise the compiler has error
  .zIndex($$.cssZIndex)
  .accessibilityText($$.cssAccessibilityLabel)
  .focusable($$.cssFocusable)
  .border($$.cssBorder)
  .shadow($$.cssShadow)
  .linearGradient($$.cssLinearGradient)
  .backgroundImage($$.cssBackgroundImage)
  .backgroundImageSize($$.cssBackgroundImageSize)
  .backgroundImagePosition($$.cssBackgroundImagePosition)
  .transform($$.cssMatrix)
  .rotate($$.cssRotate)
  .scale($$.cssScale)
  .translate($$.cssTranslate)
  .hitTestBehavior($$.hitTestBehavior)
  .onClick($$.eventClick)
}
