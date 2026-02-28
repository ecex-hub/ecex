define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'news/index' + location.search,
                    add_url: 'news/add',
                    edit_url: 'news/edit',
                    del_url: 'news/del',
                    multi_url: 'news/multi',
                    import_url: 'news/import',
                    table: 'news',
                }
            });

            var table = $("#table");

            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id',
                sortName: 'id',
                columns: [
                    [
                        {checkbox: true},
                        {field: 'id', title: __('Id')},
                        {
                            field: 'coverUrl',
                            title: "封面",
                            operate: 'LIKE',
                            formatter: Controller.api.formatter.new_images
                        },
                        {
                            field: 'title',
                            title: __('Title'),
                            operate: 'LIKE',
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },
                        {
                            field: 'type',
                            title: "新闻类型",
                            operate: false,
                            class: 'autocontent',
                            formatter: Controller.api.formatter.type
                        },
                        {
                            field: 'display_position',
                            title: "显示位置",
                            operate: false,
                            class: 'autocontent',
                            formatter: Controller.api.formatter.display_position
                        },
                        {
                            field: 'url',
                            title: "跳转链接",
                            operate: false,
                            class: 'autocontent',
                            formatter: Controller.api.formatter.url
                        },
                        {
                            field: 'itime',
                            title: __('Itime'),
                            operate: 'RANGE',
                            addclass: 'datetimerange',
                            autocomplete: false,
                            formatter: Table.api.formatter.datetime
                        },
                        {
                            field: 'operate',
                            title: __('Operate'),
                            table: table,
                            events: Table.api.events.operate,
                            formatter: Table.api.formatter.operate,
                        }
                    ]
                ]
            });

            // 为表格绑定事件
            Table.api.bindevent(table);

            table.on('post-body.bs.table', function (e, settings, json, xhr) {
                // $(".btn-add").data("area", ['60%','80%']);// 添加弹窗
                $(".btn-editone").data("area", ['95%', '95%']);// 编辑弹窗
                // $(".btn-recyclebin").data("area", ['60%','80%']);// 回收站
            });
        },
        add: function () {
            // 配置表单验证器，忽略隐藏字段
            $("form#add-form").data("validator-options", {
                ignore: ':hidden'
            });
            Controller.api.bindevent();
        },
        edit: function () {
            Controller.api.bindevent();
        },
        api: {
            bindevent: function () {
                Form.api.bindevent($("form[role=form]"));
            },
            formatter: {
                thumb: function (value, row, index) {
                    var html = '';
                    html = '<a href="' + row.coverUrl + '" target="_blank"><img src="' + row.coverUrl + '" alt="" style="max-height:60px;max-width:120px"></a>';
                    return '<div style="width:120px;margin:0 auto;text-align:center;overflow:hidden;white-space: nowrap;text-overflow: ellipsis;">' + html + '</div>';
                },
                new_images: function (value, row, index) {
                    value = !value || value.length === 0 ? '' : value.toString();
                    var classname = this.classname !== undefined ? this.classname : 'img-sm img-center';
                    var arr = value ? (value.indexOf('data:image/') === -1 ? value.split(',') : [value]) : [];
                    var html = [];

                    $.each(arr, function (i, v) {
                        v = v || '/assets/img/blank.gif';
                        var url = Fast.api.cdnurl(v, true);

                        // 处理缩略图
                        if (Config.upload.thumbstyle && !url.match(/^(\/|data:image\/)/) && url.indexOf(Config.upload.thumbstyle[0]) === -1) {
                            url += Config.upload.thumbstyle;
                        }

                        html.push('<a href="' + Fast.api.cdnurl(v, true) + '" target="_blank" title="点击查看大图">' +
                            '<img class="' + classname + '" src="' + url + '" /></a>');
                    });

                    return html.join(' ');
                },
                type: function (value, row, index) {
                    // 将 type 值转换为对应的文字和颜色标签
                    // 1 对应 "内部新闻"，2 对应 "外部新闻"
                    var typeMap = {
                        '1': { text: '内部新闻', color: 'warning' },
                        '2': { text: '外部新闻', color: 'info' },
                        '3': { text: '纯图新闻', color: 'danger' },
                        1: { text: '内部新闻', color: 'warning' },
                        2: { text: '外部新闻', color: 'info' },
                        3: { text: '纯图新闻', color: 'danger' }
                    };
                    var type = typeMap[value];
                    if (type) {
                        return '<span class="label label-' + type.color + '">' + type.text + '</span>';
                    }
                    return value || '';
                },
                display_position: function (value, row, index) {
                    // 将 display_position 值转换为对应的文字和颜色标签
                    var positionMap = {
                        '1': { text: '首页', color: 'primary' },
                        '2': { text: '平台资讯', color: 'success' },
                        '3': { text: '宣传栏目', color: 'warning' },
                        1: { text: '首页', color: 'primary' },
                        2: { text: '平台资讯', color: 'success' },
                        3: { text: '宣传栏目', color: 'warning' }
                    };
                    var position = positionMap[value];
                    if (position) {
                        return '<span class="label label-' + position.color + '">' + position.text + '</span>';
                    }
                    return value || '';
                },
                url: function (value, row, index) {
                    // 将 URL 显示为可点击的链接
                    if (!value || value === '') {
                        return '<span class="text-muted">-</span>';
                    }
                    // 确保 URL 包含协议
                    var url = value;
                    if (!url.startsWith('http://') && !url.startsWith('https://')) {
                        url = 'https://' + url;
                    }
                    // 截断过长的 URL 显示
                    var displayText = value;
                    if (displayText.length > 50) {
                        displayText = displayText.substring(0, 50) + '...';
                    }
                    return '<a href="' + url + '" target="_blank" title="' + value + '" class="text-primary">' + displayText + '</a>';
                },
            }
        }
    };
    return Controller;
});
