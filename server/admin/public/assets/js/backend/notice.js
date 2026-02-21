define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'notice/index' + location.search,
                    add_url: 'notice/add',
                    edit_url: 'notice/edit',
                    del_url: 'notice/del',
                    multi_url: 'notice/multi',
                    import_url: 'notice/import',
                    table: 'notice',
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
                            field: 'title',
                            title: __('Title'),
                            operate: false,
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },
                        {
                            field: 'subtitle',
                            title: "副标题",
                            operate: false,
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },
                        {field: 'sort', title: __('Sort')},
                        {
                            field: 'itime',
                            title: __('Itime'),
                            operate: 'RANGE',
                            addclass: 'datetimerange',
                            autocomplete: false,
                            formatter: Table.api.formatter.datetime
                        },
                        // {
                        //     field: 'utime',
                        //     title: __('Utime'),
                        //     operate: 'RANGE',
                        //     addclass: 'datetimerange',
                        //     autocomplete: false,
                        //     formatter: Table.api.formatter.datetime
                        // },
                        {
                            field: 'operate',
                            title: __('Operate'),
                            table: table,
                            events: Table.api.events.operate,
                            formatter: Table.api.formatter.operate
                        }
                    ]
                ]
            });

            // 为表格绑定事件
            Table.api.bindevent(table);

            table.on('post-body.bs.table', function (e, settings, json, xhr) {
                // $(".btn-add").data("area", ['60%','80%']);// 添加弹窗
                $(".btn-editone").data("area", ['95%','95%']);// 编辑弹窗
                // $(".btn-recyclebin").data("area", ['60%','80%']);// 回收站
            });
        },
        add: function () {
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
                    html = '<a href="' + row.image + '" target="_blank"><img src="' + row.image + '" alt="" style="max-height:60px;max-width:120px"></a>';
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
                }

            }
        }
    };
    return Controller;
});
