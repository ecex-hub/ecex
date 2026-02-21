define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'user/product/index' + location.search,
                    add_url: 'user/product/add',
                    edit_url: 'user/product/edit',
                    del_url: 'user/product/del',
                    multi_url: 'user/product/multi',
                    import_url: 'user/product/import',
                    table: 'user_product',
                }
            });

            var table = $("#table");

            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id',
                sortName: 'id',
                fixedColumns: true,
                fixedRightNumber: 1,
                columns: [
                    [
                        {checkbox: true},
                        {field: 'id', title: __('Id')},
                        {field: 'uid', title: __('Uid')},
                        {field: 'name', title: __('Name'), operate: 'LIKE', table: table, class: 'autocontent', formatter: Table.api.formatter.content},
                        {field: 'price', title: __('Price'), operate:'BETWEEN'},
                        {field: 'day', title: __('Day')},
                        {field: 'day_income', title: __('Day_income'), operate:'BETWEEN'},
                        {field: 'allowance', title: __('Allowance'), operate:'BETWEEN'},
                        {field: 'num', title: __('Num')},
                        {field: 'total_price', title: __('Total_price'), operate:'BETWEEN'},
                        {field: 'type', title: __('Type')},
                        {field: 'itime', title: __('Itime'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        {field: 'utime', title: __('Utime'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        {field: 'end_time', title: __('End_time'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        {field: 'income_price', title: __('Income_price'), operate:'BETWEEN'},
                        {field: 'product_id', title: __('Product_id')},
                        {field: 'two_day_allowance', title: __('Two_day_allowance'), operate:'BETWEEN'},
                        {field: 'two_day_type', title: __('Two_day_type')},
                        {field: 'register_date', title: __('Register_date'), operate:'RANGE', addclass:'datetimerange', autocomplete:false},
                        {field: 'oneLevel', title: __('OneLevel')},
                        {field: 'operate', title: __('Operate'), table: table, events: Table.api.events.operate, formatter: Table.api.formatter.operate}
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
