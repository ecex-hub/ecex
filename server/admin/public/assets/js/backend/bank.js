define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'bank/index' + location.search,
                    add_url: 'bank/add',
                    edit_url: 'bank/edit',
                    // del_url: 'bank/del',
                    multi_url: 'bank/multi',
                    import_url: 'bank/import',
                    table: 'bind_bank_card',
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
                        // {field: 'id', title: __('Id')},
                        // {field: 'uid', title: __('Uid')},
                        {
                            field: 'pay_type',
                            title: __('Pay_type'),
                            searchList: //{"0": "男", "1": "女"},//使用这个则显示下拉列表，用下面的function则自定义单选框
                                function (a, b) {
                                    return '<input type="radio" name="pay_type" value="" id="type1" checked="checked" /> ' +
                                        '<label for="sex1">不选择</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="pay_type" value="1" id="type2" /> ' +
                                        '<label for="sex2">银行卡</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="pay_type" value="2" id="type3" /> ' +
                                        '<label for="sex3">支付宝</label>&nbsp;&nbsp;';
                                },
                        },
                        {
                            field: 'realName',
                            title: __('RealName'),
                            operate: 'LIKE',
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },
                        {
                            field: 'bankName',
                            title: __('BankName'),
                            operate: 'LIKE',
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },
                        {
                            field: 'bankCard',
                            title: __('BankCard'),
                            operate: 'LIKE',
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },
                        // {
                        //     field: 'subBranchName',
                        //     title: __('SubBranchName'),
                        //     operate: 'LIKE',
                        //     table: table,
                        //     class: 'autocontent',
                        //     formatter: Table.api.formatter.content
                        // },
                        {
                            field: 'alipay_card',
                            title: __('Alipay_card'),
                            operate: 'LIKE',
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },

                        // {field: 'type', title: __('Type')},


                        // {
                        //     field: 'itime',
                        //     title: __('Itime'),
                        //     operate: 'RANGE',
                        //     addclass: 'datetimerange',
                        //     autocomplete: false,
                        //     formatter: Table.api.formatter.datetime
                        // },
                        // {
                        //     field: 'utime',
                        //     title: __('Utime'),
                        //     operate: 'RANGE',
                        //     addclass: 'datetimerange',
                        //     autocomplete: false,
                        //     formatter: Table.api.formatter.datetime
                        // },
                        // {
                        //     field: 'operate',
                        //     title: __('Operate'),
                        //     table: table,
                        //     events: Table.api.events.operate,
                        //     formatter: Table.api.formatter.operate
                        // }
                    ]
                ],
                search: false,
                commonSearch: false,
//可以控制是否默认显示搜索单表,false则隐藏,默认为false
                searchFormVisible: false,
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
