define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'conf/index' + location.search,
                    table: 'conf',
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
                        // {checkbox: true},
                        // {
                        //     field: 'uid', title: "用户id"
                        // },
                        // {
                        //     field: 'nickname',
                        //     title: "用户名称", operate: false
                        // },
                        // {
                        //     field: 'buy_product_money',
                        //     title: "认购金额",
                        //     operate: false,
                        // },
                        // {
                        //     field: 'itime',
                        //     title: "创建时间",
                        //     operate: false,
                        //     addclass: 'datetimerange',
                        //     autocomplete: false,
                        //     formatter: Table.api.formatter.datetime
                        // },

                    ]
                ]
            });

            // 为表格绑定事件
            // Table.api.bindevent(table);
            Controller.api.bindevent();
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
