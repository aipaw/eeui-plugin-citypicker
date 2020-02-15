# 城市选择器

## 安装

```shell script
eeui plugin install https://github.com/aipaw/eeui-plugin-citypicker
```

## 卸载

```shell script
eeui plugin uninstall https://github.com/aipaw/eeui-plugin-citypicker
```

## 引用

```js
const citypicker = app.requireModule("eeui/citypicker");
```

## 示例代码

```
<template>
    <div class="app">

        <text class="button" @click="citypicker">选择城市</text>
        <text>{{province}} {{city}} {{area}}</text>

    </div>
</template>

<style>
    .app {
        flex: 1;
        justify-content: center;
        align-items: center;
    }
    .button {
        text-align: center;
        margin-top: 20px;
        padding-top: 20px;
        padding-bottom: 20px;
        width: 220px;
        color: #ffffff;
        background-color: #00B4FF;
    }
</style>

<script>
    const citypicker = app.requireModule('citypicker');

    export default {
        data() {
            return {
                province: '浙江省',    //省份
                city: '杭州',          //城市
                area: '市辖区',        //区县
                areaOther: false,     //是否加上其它区（可选参数）
            }
        },
        methods: {
            citypicker() {
                citypicker.select({
                    province: this.province,
                    city: this.city,
                    area: this.area
                }, (result) => {
                    this.province = result.province;
                    this.city = result.city;
                    this.area = result.area;
                });
            }
        }
    };
</script>

```

## 预览效果

![](https://eeui.app/assets/img/ezgif-4-82378e086c.6766da03.png)
