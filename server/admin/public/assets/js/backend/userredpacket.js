define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'userredpacket/index' + location.search,
                    table: 'userredpacket',
                }
            });

            var table = $("#table");

            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'uid',
                sortName: 'uid',
                commonSearch: false,
                search: false,
                showToggle: false,
                showExport: false,
                columns: [
                    [
                        {checkbox: true},
                        {
                            field: 'utime',
                            title: "时间",
                            operate: false,
                            addclass: 'datetimerange',
                            autocomplete: false,
                            formatter: Table.api.formatter.datetime
                        },
                        {
                            field: 'uid', title: "用户id"
                        },
                        {
                            field: 'user.nickname',
                            title: "用户名", operate: false
                        },
                        {
                            field: 'money',
                            title: "抽奖金额",
                            operate: false,
                        },
                        {
                            field: 'type_name',
                            title: "是否指定红包",
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
