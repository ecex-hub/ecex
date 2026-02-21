define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'carousel/index' + location.search,
                    add_url: 'carousel/add',
                    edit_url: 'carousel/edit',
                    del_url: 'carousel/del',
                    multi_url: 'carousel/multi',
                    import_url: 'carousel/import',
                    table: 'carousel',
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
                            operate: 'LIKE',
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },
                        {
                            field: 'picUrl',
                            title: __('PicUrl'),
                            operate: 'LIKE',
                            formatter: Controller.api.formatter.thumb
                        },
                        {field: 'sort', title: __('Sort')},
                        // {field: 'type', title: __('Type')},
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
                    html = '<a href="' + row.picUrl + '" target="_blank"><img src="' + row.picUrl + '" alt="" style="max-height:60px;max-width:120px"></a>';
                    return '<div style="width:120px;margin:0 auto;text-align:center;overflow:hidden;white-space: nowrap;text-overflow: ellipsis;">' + html + '</div>';
                }
            }
        }
    };
    return Controller;
});
