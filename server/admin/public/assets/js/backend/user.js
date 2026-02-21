define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'user/index' + location.search,
                    add_url: 'user/add',
                    // edit_url: 'user/edit',
                    // del_url: 'user/del',
                    multi_url: 'user/multi',
                    import_url: 'user/import',
                    table: 'user',
                }
            });

            var table = $("#table");

            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'uid',
                sortName: 'uid',
                fixedColumns: true,
                fixedRightNumber: 1,
                search: false,
                columns: [
                    [
                        // {checkbox: true},
                        {field: 'uid', title: __('Uid')},
                        {
                            field: 'nickname',
                            title: __('Nickname'),
                            operate: 'LIKE',
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },
                        {
                            field: 'buy_product_money',
                            title: "认购金额",
                            operate: false,
                        },

                        {
                            field: 'InviteTotal',
                            title: __('InviteTotal'),
                            operate: false,
                            formatter: Controller.api.formatter.browser,
                        },
                        // {
                        //     field: 'total_income',
                        //     title: __('Total_income'),
                        //     operate: false,
                        // },

                        {
                            field: 'oneSharePeople',
                            title: "下1级人数",
                            operate: false,
                            formatter: Controller.api.formatter.browser1,
                        },
                        // {
                        //     field: 'oneIncome',
                        //     title: __('OneIncome'),
                        //     operate: false,
                        // },
                        {
                            field: 'twoSharePeople',
                            title: "下2级人数",
                            operate: false,
                            formatter: Controller.api.formatter.browser2,
                        },
                        // {
                        //     field: 'twoIncome',
                        //     title: __('TwoIncome'),
                        //     operate: false,
                        // },
                        {
                            field: 'threeSharePeople',
                            title: "下3级人数",
                            operate: false,
                            formatter: Controller.api.formatter.browser3,
                        },
                        {
                            field: 'other_num',
                            title: "其他等级人数",
                            operate: false,
                            formatter: Controller.api.formatter.browser4,
                        },
                        // {
                        //     field: 'threeIncome',
                        //     title: __('ThreeIncome'),
                        //     operate: false,
                        // },
                        {
                            field: 'RegisterIp',
                            title: '注册ip'
                        },
                        {
                            field: 'login_ip',
                            title: '登录ip'
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
                            title: __('IDFrontUrl'),
                            operate: false,
                            formatter: Controller.api.formatter.thumb1
                        },
                        {
                            field: 'IDOppositeUrl',
                            title: __('IDOppositeUrl'),
                            operate: false,
                            formatter: Controller.api.formatter.thumb2
                        },
                        // {field: 'bonusShare', title: __('BonusShare'), operate: 'BETWEEN'},
                        // {field: 'initialShare', title: __('InitialShare'), operate: 'BETWEEN'},
                        //
                        // {field: 'transferType', title: __('TransferType')},
                        // {field: 'e_uid', title: __('E_uid'), operate: 'LIKE'},
                        // {field: 'buy_product_money', title: __('Buy_product_money'), operate: 'BETWEEN'},
                        // {
                        //     field: 'operate',
                        //     title: __('Operate'),
                        //     table: table,
                        //     buttons: [
                        //         {
                        //             name: 'detail',
                        //             text: '收货地址',
                        //             // title: '通过',
                        //             //icon: 'fa fa-list',
                        //             classname: 'btn btn-xs btn-primary btn-dialog',
                        //             url: function (row, ths) { //row 表格接收到的数据
                        //                 return 'address/index?uid=' + row.uid;
                        //             },
                        //         },
                        //         {
                        //             name: 'detail',
                        //             text: '收款方式',
                        //             //icon: 'fa fa-list',
                        //             classname: 'btn btn-xs btn-primary btn-dialog',
                        //             url: function (row, ths) { //row 表格接收到的数据
                        //                 return 'bank/index?uid=' + row.uid;
                        //             },
                        //         }
                        //     ],
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
            },
            formatter: {
                thumb: function (value, row, index) {
                    var html = '';
                    html = '<a href="' + row.avatar + '" target="_blank"><img src="' + row.avatar + '" alt="" style="max-height:60px;max-width:120px"></a>';
                    return '<div style="width:120px;margin:0 auto;text-align:center;overflow:hidden;white-space: nowrap;text-overflow: ellipsis;">' + html + '</div>';
                },
                browser: function (value, row, index) {
                    //这里我们直接使用row的数据
                    return '<a class="btn btn-xs btn-dialog"  data-area=\'["95%","95%"]\' href="user/index?total=' + row.uid + '">' + row.InviteTotal + '</a>';
                },
                browser1: function (value, row, index) {
                    //这里我们直接使用row的数据
                    return '<a class="btn btn-xs btn-dialog"  data-area=\'["95%","95%"]\' href="user/index?oneLevel=' + row.uid + '">' + row.oneSharePeople + '</a>';
                },
                browser2: function (value, row, index) {
                    //这里我们直接使用row的数据
                    return '<a class="btn btn-xs btn-dialog"  data-area=\'["95%","95%"]\'href="user/index?twoLevel=' + row.uid + '">' + row.twoSharePeople + '</a>';
                },
                browser3: function (value, row, index) {
                    //这里我们直接使用row的数据
                    return '<a class="btn btn-xs btn-dialog"  data-area=\'["95%","95%"]\' href="user/index?threeLevel=' + row.uid + '">' + row.threeSharePeople + '</a>';
                },
                browser4: function (value, row, index) {
                    //这里我们直接使用row的数据
                    return '<a class="btn btn-xs btn-dialog"  data-area=\'["95%","95%"]\' href="user/index?otherLevel=' + row.uid + '">' + row.other_num + '</a>';
                },
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


