define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'tongji/index' + location.search,
                    add_url: 'tongji/add',
                    // edit_url: 'tongji/edit',
                    // del_url: 'tongji/del',
                    multi_url: 'tongji/multi',
                    import_url: 'tongji/import',
                    table: 'tongji',
                }
            });

            var table = $("#table");

            table.on('load-success.bs.table', function (e, data) {
                console.log(data)
                //这里可以获取从服务端获取的JSON数据
                $("#tongji1").text(data.register_num);
                $("#tongji2").text(data.real_num);
                $("#tongji3").text(data.buy_product_num);
                $("#tongji4").text(data.recharge_money);
                $("#tongji5").text(data.buy_product_money);
                $("#tongji6").text(data.withdraw_money);
                $("#tongji7").text(data.recharge_num);
                $("#tongji8").text(data.withdraw_num);
                $("#tongji9").text(data.sign_in_num);
                $("#tongji10").text(data.login_num);


                $("#one1").text(data.one_register_num);
                $("#one2").text(data.one_real_num);
                $("#one3").text(data.one_buy_product_num);
                $("#one4").text(data.one_recharge_money);
                $("#one5").text(data.one_buy_product_money);
                $("#one6").text(data.one_withdraw_money);
                $("#one7").text(data.one_recharge_num);
                $("#one8").text(data.one_withdraw_num);
                $("#one9").text(data.one_sign_in_num);
                $("#one10").text(data.one_login_num);


                $("#two1").text(data.two_register_num);
                $("#two2").text(data.two_real_num);
                $("#two3").text(data.two_buy_product_num);
                $("#two4").text(data.two_recharge_money);
                $("#two5").text(data.two_buy_product_money);
                $("#two6").text(data.two_withdraw_money);
                $("#two7").text(data.two_recharge_num);
                $("#two8").text(data.two_withdraw_num);
                $("#two9").text(data.two_sign_in_num);
                $("#two10").text(data.two_login_num);
            });

            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id',
                sortName: 'id',
                fixedColumns: true,
                fixedRightNumber: 1,
                searchFormVisible: true,
                columns: [
                    [
                        // {checkbox: true},
                        // {field: 'id', title: __('Id')},
                        {
                            field: 'day',
                            title: __('Date'),
                            operate: 'BETWEEN',
                            addclass: 'datetimepicker',
                            data: 'data-date-format="YYYY-MM-DD"', // 设置日期选择器格式为年月日
                            formatter: Table.api.formatter.date
                        },
                        {
                            field: 'register_num',
                            title: __('Register_num'),
                            operate: false,
                        },
                        {
                            field: 'real_num',
                            title: __('Real_num'),
                            operate: false,
                        },
                        {
                            field: 'buy_product_num',
                            title: __('Buy_product_num'),
                            operate: false,
                        },
                        {
                            field: 'recharge_money',
                            title: __('Recharge_money'),
                            operate: false,
                        },
                        {
                            field: 'buy_product_money',
                            title: __('Buy_product_money'),
                            operate: false,
                        },
                        {
                            field: 'withdraw_money',
                            title: __('Withdraw_money'),
                            operate: false,
                        },
                        {
                            field: 'recharge_num',
                            title: __('Recharge_num'),
                            operate: false,
                        },
                        {
                            field: 'withdraw_num',
                            title: __('Withdraw_num'),
                            operate: false,
                        },
                        {
                            field: 'sign_in_num',
                            title: "签到总人数",
                            operate: false,
                        },
                        {
                            field: 'login_num',
                            title: "登录总人数",
                            operate: false,
                        },
                        // {
                        //     field: 'operate',
                        //     title: __('Operate'),
                        //     table: table,
                        //     events: Table.api.events.operate,
                        //     formatter: Table.api.formatter.operate
                        // }
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
