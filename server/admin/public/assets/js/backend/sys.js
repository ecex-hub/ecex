define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'sys/index' + location.search,
                    add_url: 'sys/add',
                    edit_url: 'sys/edit',
                    del_url: 'sys/del',
                    multi_url: 'sys/multi',
                    import_url: 'sys/import',
                    table: 'sys',
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
                        {field: 'name', title: __('Name'), operate: false},
                        {
                            field: 'pay_mch_name',
                            title: __('Pay_mch'),
                            searchList: //{"0": "男", "1": "女"},//使用这个则显示下拉列表，用下面的function则自定义单选框
                                function (a, b) {
                                    return '<input type="radio" name="pay_mch" value="" id="pay_mch1" checked="checked" /> ' +
                                        '<label for="sex1">不选择</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="pay_mch" value="1" id="pay_mch2" /> ' +
                                        '<label for="sex2">福海支付</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="pay_mch" value="2" id="pay_mch3" /> ' +
                                        '<label for="sex3">桥头支付</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="pay_mch" value="3" id="pay_mch4" /> ' +
                                        '<label for="sex3">alin支付</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="pay_mch" value="4" id="pay_mch5" /> ' +
                                        '<label for="sex3">四海支付</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="pay_mch" value="5" id="pay_mch6" /> ' +
                                        '<label for="sex3">四海-云四方</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="pay_mch" value="6" id="pay_mch7" /> ' +
                                        '<label for="sex4">大圣支付</label>';
                                },
                        },
                        {
                            field: 'pay_type',
                            title: __('Pay_type'),
                            searchList: //{"0": "男", "1": "女"},//使用这个则显示下拉列表，用下面的function则自定义单选框
                                function (a, b) {
                                    return '<input type="radio" name="pay_type" value="" id="pay_type1" checked="checked" /> ' +
                                        '<label for="sex1">不选择</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="pay_type" value="1" id="pay_type2" /> ' +
                                        '<label for="sex2">支付宝</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="pay_type" value="2" id="pay_type3" /> ' +
                                        '<label for="sex3">微信</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="pay_type" value="3" id="pay_type4" /> ' +
                                        '<label for="sex3">银行卡</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="pay_type" value="4" id="pay_type5" /> ' +
                                        '<label for="sex4">云闪付</label>';
                                },
                        },
                        {
                            field: 'status',
                            title: __('Status'),
                            table: table,
                            formatter: Table.api.formatter.toggle,
                            searchList: //{"0": "男", "1": "女"},//使用这个则显示下拉列表，用下面的function则自定义单选框
                                function (a, b) {
                                    return '<input type="radio" name="status" value="" id="status1" checked="checked" /> ' +
                                        '<label for="sex1">不选择</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="status" value="0" id="status2" /> ' +
                                        '<label for="sex2">隐藏</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="status" value="1" id="status3" /> ' +
                                        '<label for="sex4">显示</label>';
                                },
                        },
                        {
                            field: 'min_price',
                            title: __('Min_price'),
                            operate: false,

                        },
                        {
                            field: 'max_price',
                            title: __('Max_price'),
                            operate: false,
                        },
                        {
                            field: 'sort',
                            title: __('Sort'),
                            operate: false,
                        },
                        {
                            field: 'buy_money',
                            title: __('Buy_money'),
                            operate: false,
                        },

                        // {
                        //     field: 'itime',
                        //     title: __('Itime'),
                        //     operate: 'RANGE',
                        //     addclass: 'datetimerange',
                        //     autocomplete: false,
                        //     formatter: Table.api.formatter.datetime
                        // },
                        // {field: 'utime', title: __('Utime'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
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
            }
        }
    };
    return Controller;
});
