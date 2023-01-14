#!/usr/bin/env ruby

def first_names
  %w[
    飞
    楠
    正
    欢
    晨
    阳
    腾
    雷
    宁
    健
    欣
    建
    捷
    彪
    旭
    聪
    昕
    鑫
    磊
    波
    明
    勇
    倩
    茵
    东
    琴
    丽
    琦
    娟
    刚
    军
    强
    炜
    宇进
    子轩
    海波
    丹丹
    为民
    旭东
    文杰
    松涛
    思华
    华世
    美雅
    心愿
    朝晖
    建刚
    爱国
    健林
    思聪
    相龙
    新力
    茉莉
    一涵
    新海
    茹云
    华健
    国贤
    吉祥
    伟敏
    海峰
    薇亚
    丽亚
  ]
end

def last_names
  %w[
    严
    何
    冯
    刘
    华
    卢
    叶
    吴
    周 
    唐
    夏
    姜
    孔
    孙
    岳
    廖
    张
    彭
    徐
    戴
    曹
    曾
    朱
    李
    杜
    杨
    林
    柳
    江
    汤
    涂
    牛
    王
    白
    石
    祝
    竺
    肖
    舒
    蒋
    薛
    袁
    许
    谢
    赵
    边
    邹
    郑
    郭
    钱
    陆
    陈
    顾
    马
    高
    魏
    鲁
    黄
    齐
  ]
end

def wage
  "#{Random.rand(0..60)}.#{Random.rand(0..99)}".to_f
end

def hours
  "#{Random.rand(20..50)}".to_i
end

def office
  %w[
    浦东陆家嘴
    海淀五道口
    浦东张江
    深圳南山
    南京雨花台
  ].shuffle.first
end

def title
  %w[
    后台开发
    前端开发 
    产品经理
    系统管理
    DBA
    存储管理
    云平台管理
    UI设计
  ].shuffle.first
end

def names
  retval = []
  first_names.each do |fname|
    last_names.each do |lname|
      retval.push("#{fname} #{lname}")
    end
  end
  retval
end

def rand_year
  (1998..2022).to_a.shuffle.first
end

def rand_month
  (1..12).to_a.shuffle.first.to_s.rjust(2, "0")
end

def rand_day
  (1..28).to_a.shuffle.first.to_s.rjust(2, "0")
end

def start_date
  "#{rand_year}/#{rand_month}/#{rand_day}"
end

def constants
  [
    line("Linus Torvalds", "1599.01", "40", "浦东陆家嘴", "CEO", "1998/04/16"),
    line("Sergey Brin", "1299", "40", "深圳南山", "COO", "1998/04/16"),
    line("Larry Page", "1299", "40", "浦东张江", "VP", "1998/04/16"),
    line("Benjamin Porter", "678", "40", "深圳南山", "律师", "1998/04/16"),
  ]
end

# These argument names look like typos and drive me kind of crazy, but they aren't typos.
# They are to avoid name collision with the functions defined above
def line(nam, wag, hour, offic, titl, start_dat)
  "#{nam.split(' ')[1]}\t#{nam.split(' ')[0]}\t#{wag}\t#{hour}\t#{offic}\t#{titl}\t#{start_dat}"
end

File.open('payroll.tsv', 'w') do |file|
  file.write("姓\t名\t小时工资\t工作小时\t工作职场\t头衔\t入职时间\n")
  file.write(
    names
      .map { |emp| line(emp, wage, hours, office, title, start_date) }
      .concat(constants)
      .shuffle
      .join("\n")
  )
end
