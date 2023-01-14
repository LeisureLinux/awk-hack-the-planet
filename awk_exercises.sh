#!/bin/sh
# Original repo: https://github.com/FreedomBen/awk-hack-the-planet.git
# awk 练习
# 一个 shell 脚本里的 18 个 awk 脚本
# 原先是  awk -f 01.awk payroll.tsv 这样来执行
# 首先用 generate-payroll.rb 生成 payroll.tsv 文件
#
FILE="payroll.tsv"

s00() {
	# 输出列头
	awk '
    NR == 1 {
    for (i=1; i<8; i++)
        printf "%d - %s\n", i, $i
    }' $FILE
}

s01() {
	# 找到 头衔名称包含 律师的工资
	awk '$6 == "律师" { print $1 $2 "的小时工资：" $3 }' $FILE
}

s02() {
	# 找到头衔是 CEO 的姓名
	awk '$6 ~ /^CEO$/ { printf("Our CEO: %s, %s\n", $2, $1) }' $FILE
}

s03() {
	# 找到入职日期是1998.04.16 的员工
	awk '$7 ~ /^1998\/04\/16$/ { print }' $FILE
}

s04() {
	# 找到职场是浦东陆家嘴的员工
	awk '$5 == "浦东陆家嘴" { print $1 $2 }' $FILE
	echo "以上人员在陆家嘴工作"
}

s05() {
	# 统计头衔是“后台开发”的人数
	awk '
    BEGIN { count = 0 }
    $6 == "后台开发" { count += 1 }
    END  { print "后台开发人数: " count }' $FILE
}

s06() {
	# 统计单名为“强”的人数
	awk '
    BEGIN        { count = 0 }
    $2 == "强" { count += 1 }
    END          { print "单名\"强\"的人数： " count }' $FILE
}

s07() {
	# 统计 姓 和 名 相同 的员工人数，基本没这种场景
	awk '
    BEGIN    { count = 0 }
    $1 == $2 { count += 1 }
    END      {
    printf("名和姓一样的人有 %s 个\n", (count > 0) ? count : "0") }' $FILE
}

s08() {
	s00
	echo "s08 is now s00"
}

s09() {
	# 统计某职场员工的总工资
	awk '
    BEGIN          { sum = 0 }
    $5 ~ /深圳南山/ { sum += $3 }
    END            { printf("深圳南山职场员工的工资 %.2f 元每小时\n", sum) }' $FILE
}

s10() {
	# 按照岗位统计人数
	awk '
    BEGIN           { count = 0 }
    $6 ~ /UI设计/ { count += 1 }
    END             { print "UI设计 岗位人数：" count }' $FILE
}

s11() {
	# 谁拿最高薪酬
	awk '
    BEGIN {
    highest = 0
    name = ""
}

NR != 1 {
if ($3 > highest) {
    highest = $3
    name = sprintf("%s %s", $1, $2)
}
}

END { printf "薪酬最高的人是 %s ，每小时挣 $%.2f \n", name, highest }' $FILE
}

s12() {
	# 谁的工作时长最多
	awk '
    BEGIN {
    highest = 0
    name = ""
}

NR != 1 {
if ($4 > highest) {
    highest = $4
    name = sprintf("%s%s", $1, $2)
}
}

END {
printf "%s 工作最勤奋： %d\n", name, highest
} ' $FILE
}

s13() {
	#!/usr/bin/awk -f
	# 输出指定的字段
	awk '
    {
        for (i = 3; i <= NF; i++) {
            #printf FS$i
            printf "%s\t",$i
        }
        print NL
    }' $FILE
}

s14() {
	#!/usr/bin/awk -f
	# 添加行号
	awk '
    {
        printf "%s:\t", NR
        for (i = 3; i <= NF; i++) {
            #printf FS$i
            printf "%s\t", $i
        }
        print NL # New line
    }' $FILE
}

s15() {
	# 不同的头衔数
	awk 'NR != 1 { print $6 }' $FILE |
		sort |
		uniq |
		awk 'END { print "不同头衔的数量：", NR }'
}

s16() {
	# 平均薪酬
	awk '
        function getName(first, last) {
        return sprintf("%s %s", $2, $1)
    }

    BEGIN {
    sum = 0
    count = 0
}

NR != 1 {
sum += $3
count += 1
}

END {
printf("平均薪酬每小时： %.2f 元\n", sum / count)
}' $FILE
}

s17() {
	# 同名同姓的人
	awk '
    function getName(first, last) {
    #return sprintf("%s%s", first, last)
    return first last
}

BEGIN {
count = 0
marker = 9999
}

NR != 1 {
if (names[getName($1, $2)] == marker) {
    count += 1
}
names[getName($1, $2)] = marker
}

END {
printf("There are %d people out of %d with identical first and last names\n", count, NR)
} ' $FILE
}

s18() {
	# 第一个入职的员工
	awk '
    function getName(first, last) {
    return sprintf("%s%s", $1, $2)
}

BEGIN {
lowestYear = 9999
lowestMonth = 99
lowestDay = 99
name = ""
}

NR != 1 {
split($7, date, "/")
if (date[1] < lowestYear) {
    lowestYear = date[1]
    lowestMonth = date[2]
    lowestDay = date[3]
    name = getName($1, $2)
}
if (date[1] == lowestYear && date[2] < lowestMonth) {
    lowestMonth = date[2]
    lowestDay = date[3]
    name = getName($1, $2)
}
if (date[1] == lowestYear && date[2] == lowestMonth && date[3] < lowestDay) {
    lowestDay = date[3]
    name = getName($1, $2)
}
}

END {
printf "%s 是第一个入职的员工，入职日期： %d/%d/%d\n", name, lowestYear, lowestMonth, lowestDay
}' $FILE
}

help() {
	echo "Syntax: $0 function_name"
	exit 0
}

# Main Prog.
[ -z "$1" ] && help
type $1 >/dev/null
[ $? != 0 ] && help
$1
