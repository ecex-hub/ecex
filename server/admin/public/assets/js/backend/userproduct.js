define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

        var Controller = {
            index: function () {
                // 初始化表格参数配置
                Table.api.init({
                    extend: {
                        index_url: 'userproduct/index' + location.search,
                        add_url: 'userproduct/add',
                        // edit_url: 'userproduct/edit',
                        // del_url: 'userproduct/del',
                        multi_url: 'userproduct/multi',
                        import_url: 'userproduct/import',
                        table: 'video',
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
                    search: false,
                    columns: [
                        [
                            {
                                field: 'id',
                                title: __('Id')
                            },
                            {
                                field: 'user.uid',
                                title: __('Uid')
                            },
                            {
                                field: 'user.nickname',
                                title: __('Nickname')
                            },
                            {
                                field: 'name',
                                title: __('Name'),
                                operate: false,
                                table: table,
                                class: 'autocontent',
                                formatter: Table.api.formatter.content
                            },
                            {
                                field: 'total_price',
                                title: __('Total_price'),
                                operate: false,
                                formatter: Table.api.formatter.content
                            },
                            {
                                field: 'num',
                                title: __('Num'),
                                operate: false,
                                formatter: Table.api.formatter.content
                            },
                            {
                                field: 'register_date',
                                title: __('Register_date'),
                                operate: false,
                                formatter: Table.api.formatter.content
                            },
                            {
                                field: 'end_time',
                                title: __('End_time'),
                                addclass: 'datetimerange',
                                autocomplete: false,
                                operate: false,
                                formatter: Table.api.formatter.datetime
                            },
                            {
                                field: 'day',
                                title: __('Day'),
                                operate: false,
                                formatter: Table.api.formatter.content
                            },
                            {
                                field: 'total_pay_back',
                                title: __('Total_pay_back'),
                                operate: false,
                                formatter: Table.api.formatter.content
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
            }
        };
        return Controller;
    }
);
