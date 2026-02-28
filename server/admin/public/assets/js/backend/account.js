define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        team: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'account/index' + location.search,
                    add_url: 'account/add',
                    // edit_url: 'account/edit',
                    // del_url: 'account/del',
                    multi_url: 'account/multi',
                    import_url: 'account/import',
                    table: 'account_info',
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
                        {field: 'uid', title: __('Uid')},
                        {
                            field: 'nickname',
                            title: __('Nickname'),
                            operate: 'LIKE',
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },
                        {field: 'oneLevel', title: __('OneLevel')},                      
                        
                        {field: 'oneSharePeople', title: '一级人数', operate: false},
                        {field: 'twoSharePeople', title:'二级人数', operate: false},                                                
                        {field: 'threeSharePeople', title:'三级人数', operate: false},                                                
                        {field: 'threeSharePeople', title:'其他人数', operate: false}
                    ]
                ]
            });

            // 为表格绑定事件
            Table.api.bindevent(table);

            $(document).on("click", ".btn-export", function () {
                var url = $(this).attr('data-url');
                console.log(url)
                window.open(url);
            });
        },
		 tongji: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'account/index' + location.search,
                    add_url: 'account/add',
                    // edit_url: 'account/edit',
                    // del_url: 'account/del',
                    multi_url: 'account/multi',
                    import_url: 'account/import',
                    table: 'account_info',
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
                        {field: 'uid', title: __('Uid')},
                        {
                            field: 'nickname',
                            title: __('Nickname'),
                            operate: 'LIKE',
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },
                        {field: 'oneLevel', title: __('OneLevel')},                      
                        {
                            field: 'account',
                            title: __('Account'),
                            operate: 'LIKE',
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },
                        {field: 'rechargeAllMoney', title: '总充值', operate: false},
                        {field: 'withdrawalAllMoney', title:'总提现', operate: false},                                                
                        {
                            field: 'realName',
                            title: __('RealName'),
                            operate: false,
                        },
                        {field: 'IDCard', title: __('IDCard'), operate: 'LIKE'},
                        {
                            field: 'itime',
                            title: __('Itime'),
                            operate: false,
                            formatter: Table.api.formatter.datetime
                        }                      
                       
                    ]
                ]
            });

            // 为表格绑定事件
            Table.api.bindevent(table);

            $(document).on("click", ".btn-export", function () {
                var url = $(this).attr('data-url');
                console.log(url)
                window.open(url);
            });
        },
		index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'account/index' + location.search,
                    add_url: 'account/add',
                    // edit_url: 'account/edit',
                    // del_url: 'account/del',
                    multi_url: 'account/multi',
                    import_url: 'account/import',
                    table: 'account_info',
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
                        {field: 'uid', title: __('Uid')},
                        {
                            field: 'nickname',
                            title: __('Nickname'),
                            operate: 'LIKE',
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },
                        {field: 'oneLevel', title: __('OneLevel')},                      
                        {
                            field: 'account',
                            title: __('Account'),
                            operate: 'LIKE',
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },
                        {field: 'rechargeAllMoney', title: __('RechargeAllMoney'), operate: false},
                        {field: 'money', title: __('Money'), operate: false},
                        {field: 'pay_back', title: __('Pay_back'), operate: false},
                        {field: '-', title: '待审核钱包'},
                       // {field: 'allowance', title: __('Allowance'), operate: false},
                        //{field: 'dream_fund', title: "国众基金", operate: false},
                        {
                            field: 'realName',
                            title: __('RealName'),
                            operate: false,
                        },
                        {field: 'IDCard', title: __('IDCard'), operate: 'LIKE'},

                        {
                            field: 'RegisterIp', title: __('RegisterIp'), operate: 'LIKE'
                        },
                        {
                            field: 'login_ip', title: "登录IP", operate: 'LIKE'
                        },
                        {
                            field: 'status_name', title: "用户状态", operate: false
                        },
                        {
                            field: 'itime',
                            title: __('Itime'),
                            operate: false,
                            formatter: Table.api.formatter.datetime
                        },
                        {
                            field: 'last_login_time',
                            title: "最后登录时间",
                            operate: 'BETWEEN',
                            addclass: 'datetimepicker',
                            formatter: Table.api.formatter.datetime
                        },
                        {
                            field: 'limit_time',
                            title: "提现时间限制",
                            operate: false,
                            formatter: function (value, row, index) {
                                if (value == -1) {
                                    return '永久';
                                }
                                return Table.api.formatter.datetime.call(this, value);
                            }
                        },
                        {
                            field: 'operate',
                            title: __('Operate'),
                            table: table,
                            // cellStyle: {css: {"max-width": "100px"}},
                            buttons: [
                                {
                                    name: 'detail',
                                    text: '上下分',
                                    // title: '通过',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-primary btn-dialog',
                                    url: function (row, ths) { //row 表格接收到的数据
                                        return 'account/edit/ids/' + row.uid;
                                    },
                                },                          
                                {
                                    name: 'detail',
                                    text: '收款方式',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-primary btn-dialog',
                                    url: function (row, ths) { //row 表格接收到的数据
                                        return 'bank/index?uid=' + row.uid;
                                    },
                                },
                                {
                                    name: 'detail',
                                    text: '修改客户信息',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-primary btn-dialog',
                                    url: function (row, ths) { //row 表格接收到的数据
                                        return 'account/edita/ids/' + row.uid;
                                    },
                                },
                                {
                                    name: 'detail',
                                    text: '冻结用户',
                                    title: '通过',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-primary btn-click',
                                    click: function (ths, row) {
                                        Fast.api.ajax({
                                            url: 'account/freeze',
                                            data: {
                                                uid: row.uid,
                                            }
                                        }, function (data, ret) {
                                            //成功的回调
                                            $(".btn-refresh").trigger("click");
                                        }, function (data, ret) {
                                            //失败的回调
                                            Toastr.error(ret.msg || "冻结失败！");
                                        });
                                    }
                                },
                                {
                                    name: 'detail',
                                    text: '解冻用户',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-primary btn-click',
                                    click: function (ths, row) {
                                        Fast.api.ajax({
                                            url: 'account/unfreeze',
                                            data: {
                                                uid: row.uid,
                                            }
                                        }, function (data, ret) {
                                            //成功的回调
                                            $(".btn-refresh").trigger("click");
                                        }, function (data, ret) {
                                            //失败的回调
                                        });
                                    }
                                },
                                {
                                    name: 'detail',
                                    text: '删除用户',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-danger btn-click',
                                    click: function (ths, row) {

                                        // 弹出确认框
                                        Layer.confirm("确定要删除该用户吗？此操作不可撤销！", {icon: 3, title: "警告"}, function (index) {
                                            // 用户确认后发送请求
                                            Fast.api.ajax({
                                                url: 'account/del',
                                                data: {
                                                    uid: row.uid,
                                                },
                                                type: "POST",
                                            }, function (data, ret) {
                                                // 成功回调
                                                $(".btn-refresh").trigger("click");
                                            }, function (data, ret) {
                                                // 失败回调
                                                Toastr.error(ret.msg || "删除失败！");
                                            });
                                            Layer.close(index); // 关闭确认框
                                        });
                                    }
                                },
                                {
                                    name: 'detail',
                                    text: '提现封禁-3',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-danger btn-click',
                                    click: function (ths, row) {
                                        Fast.api.ajax({
                                            url: 'account/notWithdrawal',
                                            data: {
                                                uid: row.uid,
                                                day: 3,
                                            }
                                        }, function (data, ret) {
                                            //成功的回调
                                            $(".btn-refresh").trigger("click");
                                        }, function (data, ret) {
                                            //失败的回调
                                        });
                                    }
                                },
                                {
                                    name: 'detail',
                                    text: '提现封禁-5',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-danger btn-click',
                                    click: function (ths, row) {
                                        Fast.api.ajax({
                                            url: 'account/notWithdrawal',
                                            data: {
                                                uid: row.uid,
                                                day: 5,
                                            }
                                        }, function (data, ret) {
                                            //成功的回调
                                            $(".btn-refresh").trigger("click");
                                        }, function (data, ret) {
                                            //失败的回调
                                        });
                                    }
                                },
                                {
                                    name: 'detail',
                                    text: '提现封禁-10',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-danger btn-click',
                                    click: function (ths, row) {
                                        Fast.api.ajax({
                                            url: 'account/notWithdrawal',
                                            data: {
                                                uid: row.uid,
                                                day: 10,
                                            }
                                        }, function (data, ret) {
                                            //成功的回调
                                            $(".btn-refresh").trigger("click");
                                        }, function (data, ret) {
                                            //失败的回调
                                        });
                                    }
                                },
                                {
                                    name: 'detail',
                                    text: '提现封禁-永久',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-danger btn-click',
                                    click: function (ths, row) {
                                        Fast.api.ajax({
                                            url: 'account/notWithdrawal',
                                            data: {
                                                uid: row.uid,
                                                day: -1,
                                            }
                                        }, function (data, ret) {
                                            //成功的回调
                                            $(".btn-refresh").trigger("click");
                                        }, function (data, ret) {
                                            //失败的回调
                                        });
                                    }
                                },
                                {
                                    name: 'detail',
                                    text: '解除提现封禁',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-danger btn-click',
                                    click: function (ths, row) {
                                        Fast.api.ajax({
                                            url: 'account/notWithdrawal',
                                            data: {
                                                uid: row.uid,
                                                day: 0,
                                            }
                                        }, function (data, ret) {
                                            //成功的回调
                                            $(".btn-refresh").trigger("click");
                                        }, function (data, ret) {
                                            //失败的回调
                                        });
                                    }
                                }
                            ],
                            events: Table.api.events.operate,
                            // formatter: Table.api.formatter.operate
                            // formatter: function (value, row, index) {
                            //     var buttons = [];
                            //     buttons.push('<a href="account/edita/ids/' + row.uid + '"  class="btn btn-xs btn-primary btn-dialog" data-table-id="table" data-field-index="16" data-row-index="0" data-button-index="0">修改客户信息</a><br/>');
                            //     buttons.push('<a href="javascript:;"  class="btn btn-xs btn-primary btn-click" title="通过" data-table-id="table" data-field-index="16" data-row-index="0" data-button-index="4" style="margin-right: 10px"><i class=""></i> 冻结用户</a>');
                            //     buttons.push('<a href="javascript:;"  class="btn btn-xs btn-primary btn-click" title="解冻用户" data-table-id="table" data-field-index="16" data-row-index="0" data-button-index="5"><i class=""></i> 解冻用户</a>');
                            //     buttons.push('<a href="javascript:;" class="btn btn-xs btn-danger btn-click" title="删除用户" data-table-id="table" data-field-index="16" data-row-index="0" data-button-index="6" style="margin-bottom: 10px"><i class=""></i> 删除用户</a>');
                            //     return "<td style=\"display: block; text-align: center; vertical-align: middle;\">" + buttons.join('') + "</td>";
                            // }
                            formatter: function (value, row, index) {
                                console.log(index)
                                var buttons = [];
                                var mainButtons = [
                                    '<a href="account/edit/ids/' + row.uid + '" class="btn btn-xs btn-primary btn-dialog">上下分</a>',
                                    '<a href="bank/index?uid=' + row.uid + '" class="btn btn-xs btn-primary btn-dialog">收款地址</a>',
                                    '<a href="account/edita/ids/' + row.uid + '" class="btn btn-xs btn-primary btn-dialog">修改客户信息</a>',
                                ];
                                var moreButtons = [
                                    '<li><a href="javascript:;"  class="btn btn-xs btn-click" title="冻结用户" data-table-id="table" data-field-index="18" data-row-index=' + index + ' data-button-index="4">冻结用户</a></li>',
                                    '<li><a href="javascript:;"  class="btn btn-xs btn-click" title="解冻用户" data-table-id="table" data-field-index="18" data-row-index=' + index + ' data-button-index="5">解冻用户</a></li>',
                                    '<li><a href="javascript:;"  class="btn btn-xs btn-click" title="删除用户" data-table-id="table" data-field-index="18" data-row-index=' + index + ' data-button-index="6">删除用户</a></li>',
                                    '<li><a href="javascript:;"  class="btn btn-xs btn-click" title="提现封禁" data-table-id="table" data-field-index="18" data-row-index=' + index + ' data-button-index="7">提现封禁:3天</a></li>',
                                    '<li><a href="javascript:;"  class="btn btn-xs btn-click" title="提现封禁" data-table-id="table" data-field-index="18" data-row-index=' + index + ' data-button-index="8">提现封禁:5天</a></li>',
                                    '<li><a href="javascript:;"  class="btn btn-xs btn-click" title="提现封禁" data-table-id="table" data-field-index="18" data-row-index=' + index + ' data-button-index="9">提现封禁:10天</a></li>',
                                    '<li><a href="javascript:;"  class="btn btn-xs btn-click" title="提现封禁" data-table-id="table" data-field-index="18" data-row-index=' + index + ' data-button-index="10">提现封禁:永久</a></li>',
                                    '<li><a href="javascript:;"  class="btn btn-xs btn-click" title="解除提现封禁" data-table-id="table" data-field-index="18" data-row-index=' + index + ' data-button-index="11">解除提现封禁</a></li>',
                                ];

                                // 拼接主要按钮
                                buttons = buttons.concat(mainButtons);

                                // 如果有更多按钮则添加下拉菜单
                                if (moreButtons.length > 0) {
                                    buttons.push(`
                                <div class="btn-group">
                                    <button type="button" class="btn btn-xs btn-primary dropdown-toggle" data-toggle="dropdown">
                                        更多操作 <span class="caret"></span>
                                    </button>
                                    <ul class="dropdown-menu">
                                        ${moreButtons.join('')}
                                    </ul>
                                </div>
                            `);
                                }

                                return buttons.join(' ');
                            }


                        }
                    ]
                ]
            });

            // 为表格绑定事件
            Table.api.bindevent(table);

            $(document).on("click", ".btn-export", function () {
                var url = $(this).attr('data-url');
                console.log(url)
                window.open(url);
            });
        },
        add: function () {
            Controller.api.bindevent();
        },
        edit: function () {
            Controller.api.bindevent();
        },
        edita: function () {
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
                }
            }
        }
    };
    return Controller;
});
