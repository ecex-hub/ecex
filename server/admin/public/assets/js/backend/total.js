define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'total/index' + location.search,
                    add_url: 'total/add',
                    edit_url: 'total/edit',
                    del_url: 'total/del',
                    multi_url: 'total/multi',
                    import_url: 'total/import',
                    table: 'total',
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
                        {
                            field: 'uid', title: "用户id"
                        },
                        {
                            field: 'nickname',
                            title: "用户名称", operate: false
                        },
                        {
                            field: 'buy_product_money',
                            title: "认购金额",
                            operate: false,
                        },
                        {
                            field: 'itime',
                            title: "注册时间",
                            operate: false,
                            addclass: 'datetimerange',
                            autocomplete: false,
                            formatter: Table.api.formatter.datetime
                        },
                        {
                            field: 'InviteTotal',
                            title: '总人数',
                            operate: false,
                        },
                        {
                            field: 'oneSharePeople',
                            title: "下1级人数",
                            operate: false,
                        },
                        {
                            field: 'twoSharePeople',
                            title: "下2级人数",
                            operate: false,
                        },
                        {
                            field: 'threeSharePeople',
                            title: "下3级人数",
                            operate: false,
                        },


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
