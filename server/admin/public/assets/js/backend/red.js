define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'red/index' + location.search,
                    add_url: 'red/add',
                    // edit_url: 'user/edit',
                    // del_url: 'user/del',
                    // multi_url: 'user/multi',
                    // import_url: 'user/import',
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
                        {field: 'uid', title: '用户id'},
                        {
                            field: 'nickname',
                            title: '用户名',
                            operate: 'LIKE',
                            table: table,
                            class: 'autocontent',
                        },
                        {
                            field: 'normal_red',
                            title: "普通红包剩余抽奖次数",
                            operate: false,
                        },
                        {
                            field: 'to_red',
                            title: "指定红包剩余抽奖次数",
                            operate: false,
                        },

                        {
                            field: 'to_money',
                            title: "指定红包金额",
                            operate: false,
                        },

                        {
                            field: 'operate',
                            title: __('Operate'),
                            table: table,
                            buttons: [
                                {
                                    name: 'detail',
                                    text: '红包明细',
                                    // title: '通过',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-primary btn-dialog',
                                    url: function (row, ths) { //row 表格接收到的数据
                                        return 'userredpacket/index?uid=' + row.uid;
                                    },
                                },
                            ],
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
            },
            formatter: {
                thumb: function (value, row, index) {
                    var html = '';
                    html = '<a href="' + row.avatar + '" target="_blank"><img src="' + row.avatar + '" alt="" style="max-height:60px;max-width:120px"></a>';
                    return '<div style="width:120px;margin:0 auto;text-align:center;overflow:hidden;white-space: nowrap;text-overflow: ellipsis;">' + html + '</div>';
                },
                browser: function (value, row, index) {
                    //这里我们直接使用row的数据
                    return '<a class="btn btn-xs btn-dialog" href="user/index?total=' + row.uid + '">' + row.InviteTotal + '</a>';
                },
                browser1: function (value, row, index) {
                    //这里我们直接使用row的数据
                    return '<a class="btn btn-xs btn-dialog" href="one/index?oneLevel=' + row.uid + '">' + row.oneSharePeople + '</a>';
                },
                browser2: function (value, row, index) {
                    //这里我们直接使用row的数据
                    return '<a class="btn btn-xs btn-dialog" href="two/index?oneLevel=' + row.uid + '">' + row.twoSharePeople + '</a>';
                },
                browser3: function (value, row, index) {
                    //这里我们直接使用row的数据
                    return '<a class="btn btn-xs btn-dialog" href="three/index?oneLevel=' + row.uid + '">' + row.threeSharePeople + '</a>';
                },
                browser4: function (value, row, index) {
                    //这里我们直接使用row的数据
                    return '<a class="btn btn-xs btn-dialog" href="four/index?oneLevel=' + row.uid + '">' + row.other_num + '</a>';
                },
            },
        }
    };
    return Controller;
});
