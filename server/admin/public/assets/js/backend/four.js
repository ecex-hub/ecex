define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'four/index' + location.search,
                    add_url: 'four/add',
                    edit_url: 'four/edit',
                    del_url: 'four/del',
                    multi_url: 'four/multi',
                    import_url: 'four/import',
                    table: 'four',
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
                            field: 'RegisterIp',
                            title: '注册ip',
                            operate: false,
                        },
                        {
                            field: 'login_ip',
                            title: '登录ip',
                            operate: false,
                        },
                        {
                            field: 'itime',
                            title: '注册时间',
                            operate: false,
                            formatter: Table.api.formatter.datetime
                        },
                        {
                            field: 'last_login_time',
                            title: '登录时间',
                            operate: false,
                            formatter: Table.api.formatter.datetime
                        },
                        {
                            field: 'IDFrontUrl',
                            title: "身份证正面 国徽",
                            operate: false,
                            formatter: Controller.api.formatter.thumb1
                        },
                        {
                            field: 'IDOppositeUrl',
                            title: "身份证反面 人像",
                            operate: false,
                            formatter: Controller.api.formatter.thumb2
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
            },
            formatter: {
                thumb1: function (value, row, index) {
                    var html = '';
                    html = '<a href="' + row.IDOppositeUrl + '" target="_blank"><img src="' + row.IDOppositeUrl + '" alt="" style="max-height:60px;max-width:120px"></a>';
                    return '<div style="width:120px;margin:0 auto;text-align:center;overflow:hidden;white-space: nowrap;text-overflow: ellipsis;">' + html + '</div>';
                },
                thumb2: function (value, row, index) {
                    var html = '';
                    html = '<a href="' + row.IDOppositeUrl + '" target="_blank"><img src="' + row.IDOppositeUrl + '" alt="" style="max-height:60px;max-width:120px"></a>';
                    return '<div style="width:120px;margin:0 auto;text-align:center;overflow:hidden;white-space: nowrap;text-overflow: ellipsis;">' + html + '</div>';
                },
            },
        }
    };
    return Controller;
});
