define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'bill/index' + location.search,
                    add_url: 'bill/add',
                    // edit_url: 'bill/edit',
                    // del_url: 'bill/del',
                    multi_url: 'bill/multi',
                    import_url: 'bill/import',
                    table: 'bill_record',
                }
            });

            var table = $("#table");

            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id',
                sortName: 'id',
                search: false,
                columns: [
                    [
                        {checkbox: true},
                        {
                            field: 'id',
                            title: __('Id'),
                            operate: false
                        },
                        {
                            field: 'user.oneLevel', title: "上级id"
                        },
                        {
                            field: 'uid', title: __('Uid')
                        },
                        {
                            field: 'user.nickname', title: __('Nickname')
                        },
                        {
                            field: 'money', title: __('Money'), operate: false
                        },
                        {field: 'money_type', title: __('Money_type'), operate: false},
                        {field: 'bill_unit', title: __('Bill_unit'), operate: false},
                        {field: 'bill_type', title: __('Bill_type'), operate: false},
                        {
                            field: 'admin.id', title: "管理员id"
                        },
                        {
                            field: 'admin.nickname', title: "管理员名称"
                        },
                        {
                            field: 'ext_content', title: "备注"
                        },
                        // {
                        //     field: 'ext_id',
                        //     title: __('Ext_id')
                        // },
                        {
                            field: 'itime',
                            title: __('Itime'),
                            operate: false,
                            addclass: 'datetimerange',
                            autocomplete: false,
                            formatter: Table.api.formatter.datetime
                        },
                        // {field: 'utime', title: __('Utime'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        // {field: 'operate', title: __('Operate'), table: table, events: Table.api.events.operate, formatter: Table.api.formatter.operate}
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
            }
        }
    };
    return Controller;
});
