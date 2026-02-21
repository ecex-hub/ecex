define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'signb/index' + location.search,
                    //add_url: 'signa/add',
                    // edit_url: 'newsignin/edit',
                    // del_url: 'newsignin/del',
                    // multi_url: 'newsignin/multi',
                    // import_url: 'newsignin/import',
                    table: 'signb',
                }
            });

            var table = $("#table");

            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'day',
                sortName: 'day',
                pagination: false,
                commonSearch: false,
                search: false,
                showToggle: false,
                showExport: false,
                columns: [
                    [
                        {checkbox: true},
                        {
                            field: 'uid',
                            visible: false,
                        },
                        {
                            field: 'day',
                            title: "已签天数",
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
            }
        }
    };
    return Controller;
});
