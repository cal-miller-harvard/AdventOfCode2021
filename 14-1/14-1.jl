using DelimitedFiles
using BenchmarkTools
import Base.convert

mutable struct LinkedList
    val::Char
    next::LinkedList
    LinkedList(val) = (x = new(); x.val=val; x.next=x)
    LinkedList(val, next) = new(val, next)
end

function toLinkedList(v)
    head = LinkedList(v[1])
    tail = head
    for c in 2:length(v)
        tail.next = LinkedList(v[c])
        tail = tail.next
    end
    tail.next = tail
    return head
end

function toVector(l)
    v = Vector{typeof(l.val)}()
    while l.next != l
        push!(v, l.val)
        l = l.next
    end
    push!(v, l.val)
    return v
end

function readInput(path)
    open(path, "r") do f
        data = readdlm(f,' ', String, '\n')
        template = toLinkedList(collect(data[1,1]))
        n_rules = size(data)[1]-1
        rules = Matrix{Char}(undef, n_rules, 3)
        for i in 1:n_rules
            rules[i,1] = data[i+1,1][1]
            rules[i,2] = data[i+1,1][2]
            rules[i,3] = data[i+1,3][1]
        end
        return template, rules
    end
end

function solve(input)
    template, rules = input
    l = deepcopy(template)
    function step!(l, rules)
        head = l
        while head.next != head
            for r in eachrow(rules)
                if head.val == r[1] && head.next.val == r[2]
                    head.next = LinkedList(r[3], head.next)
                    head = head.next
                    break
                end
            end
            head = head.next
        end
        return l
    end
    for _ in 1:10
        step!(l, rules)
    end
    lVec = toVector(l)
    counts = sort!([count(==(i), lVec) for i in unique(lVec)])
    return counts[end] - counts[1]
end

input = readInput("in.txt")
benchmark = @benchmark solve(input)
display(benchmark)
result = solve(input)
display(result)