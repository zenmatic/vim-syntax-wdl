task hello {
  input {
    String pattern
    File in
  }

  command {
    egrep '${pattern}' '${in}'
  }

  runtime {
    docker: "broadinstitute/my_image"
  }

  output {
    Array[String] matches = read_lines(stdout())
  }
}

workflow wf {
  call hello
}

workflow example {
  input {
    Array[File] files
  }
  scatter(path in files) {
    call hello {input: in=path}
  }
}

Int i = 0                  # An integer value
Float f = 27.3             # A floating point number
Boolean b = true           # A boolean true/false
String s = "hello, world"  # A string value
File f = "path/to/file"    # A file

Array[X] xs = [x1, x2, x3]                    # An array of Xs
Map[P,Y] p_to_y = { p1: y1, p2: y2, p3: y3 }  # A map from Ps to Ys
Pair[X,Y] x_and_y = (x, y)                    # A pair of one X and one Y
Object o = { "field1": f1, "field2": f2 }     # Object keys are always `String`s

task foobar {
  input {
    File in
  }
  command {
    sh setup.sh ${in}
  }
  output {
    File results = stdout()
  }
}

import "other.wdl" as other

task test {
  String my_var
  command {
    ./script ${my_var}
  }
  output {
    File results = stdout()
  }
}

workflow wf {
  Array[String] arr = ["a", "b", "c"]
  call test
  call test as test2
  call other.foobar
  output {
    test.results
    foobar.results
  }
  scatter(x in arr) {
    call test as scattered_test {
      input: my_var=x
    }
  }
}

import "other.wdl" as ns
workflow wf {
  call ns.ns2.task
}

task test {
  input {
    String var
  }
  command {
    ./script ${var}
  }
  output {
    String value = read_string(stdout())
  }
}

task test2 {
  input {
    Array[String] array
  }
  command {
    ./script ${write_lines(array)}
  }
  output {
    Int value = read_int(stdout())
  }
}

workflow wf {
  call test as x {input: var="x"}
  call test as y {input: var="y"}
  Array[String] strs = [x.value, y.value]
  call test2 as z {input: array=strs}
}

Boolean morning = ...
String greeting = "good " + if morning then "morning" else "afternoon"

Int array_length = length(array)
runtime {
  memory: if array_length > 100 then "16GB" else "8GB"
}

workflow wf {
  input {
    Object obj
    Object foo
  }
  # This would cause a syntax error,
  # because foo is defined twice in the same namespace.
  call foo {
    input: var=obj.attr # Object attribute
  }

  call foo as foo2 {
    input: var=foo.out # Task output
  }
}

Array[String] a = ["a", "b", "c"]
Array[Int] b = [0,1,2]

Map[Int, Int] = {1: 10, 2: 11}
Map[String, Int] = {"a": 1, "b": 2}

Object f = object {
  a: 10,
  b: 11
}

String a = "beware"
String b = "key"
String c = "lookup"

# What are the keys to this object?
Object object_syntax = object {
  a: 10,
  b: 11,
  c: 12
}

# What are the keys to this object?
Object map_coercion = {
  a: 10,
  b: 11,
  c: 12
}

Pair[Int, String] twenty_threes = (23, "twenty-three")

version draft-3

import "http://example.com/lib/analysis_tasks" as analysis
import "http://example.com/lib/stdlib"


workflow wf {
  input {
    File bam_file
  }
  # file_size is from "http://example.com/lib/stdlib"
  call stdlib.file_size {
    input: file=bam_file
  }
  call analysis.my_analysis_task {
    input: size=file_size.bytes, file=bam_file
  }
}

task t {
  input {
    Int i
    File f
  }

  # [... other task sections]
}

task t {
  input {
    Object inputs
  }
  File objects_json = write_json(inputs)

  # [... other task sections]
}

task test {
  input {
    String flags
  }
  command {
    ps ~{flags}
  }
}

task test {
  String flags
  command <<<
    ps ~{flags}
  >>>
}

task default_test {
  input {
    String? s
  }
  command {
    ./my_cmd ${default="foobar" s}
  }
}

task heredoc {
  input {
    File in
  }

  command<<<
  python <<CODE
    with open("${in}") as fp:
      for line in fp:
        if not line.startswith('#'):
          print(line.strip())
  CODE
  >>>
}

output {
  Int threshold = read_int("threshold.txt")
}

output {
  Array[String] quality_scores = read_lines("${sample_id}.scores.txt")
}

output {
  String a = "a"
  String ab = a + "b"
}

output {
  Array[File] output_bams = glob("*.bam")
}

task example {
  input {
    String prefix
    File bam
  }
  command {
    python analysis.py --prefix=${prefix} ${bam}
  }
  output {
    File analyzed = "${prefix}.out"
    File bam_sibling = "${bam}.suffix"
  }
}

task test {
  command {
    python script.py
  }
  runtime {
    docker: ["ubuntu:latest", "broadinstitute/scala-baseimage"]
  }
}

task test {
  input {
    String ubuntu_version
  }
  command {
    python script.py
  }
  runtime {
    docker: "ubuntu:" + ubuntu_version
  }
}

task docker_test {
  input {
    String arg
  }
  command {
    python process.py ${arg}
  }
  runtime {
    docker: "ubuntu:latest"
  }
}

task memory_test {
  input {
    String arg
  }

  command {
    python process.py ${arg}
  }
  runtime {
    memory: "2GB"
  }
}

task wc {
  File f
  Boolean l = false
  String? region
  parameter_meta {
    f : { help: "Count the number of lines in this file" },
    l : { help: "Count only lines" }
    region: {help: "Cloud region",
             suggestions: ["us-west", "us-east", "asia-pacific", "europe-central"]}
  }
  command {
    wc ${true="-l", false=' ' l} ${f}
  }
  output {
     String retval = stdout()
  }
}

task hello_world {
  command {echo hello world}
}

task one_and_one {
  input {
    String pattern
    File infile
  }
  command {
    grep ${pattern} ${infile}
  }
  output {
    File filtered = stdout()
  }
}

task runtime_meta {
  input {
    String memory_mb
    String sample_id
    String param
    String sample_id
  }
  command {
    java -Xmx${memory_mb}M -jar task.jar -id ${sample_id} -param ${param} -out ${sample_id}.out
  }
  output {
    File results = "${sample_id}.out"
  }
  runtime {
    docker: "broadinstitute/baseimg"
  }
  parameter_meta {
    memory_mb: "Amount of memory to allocate to the JVM"
    param: "Some arbitrary parameter"
    sample_id: "The ID of the sample in format foo_bar_baz"
  }
  meta {
    author: "Joe Somebody"
    email: "joe@company.org"
  }
}

task bwa_mem_tool {
  input {
    Int threads
    Int min_seed_length
    Int min_std_max_min
    File reference
    File reads
  }
  command {
    bwa mem -t ${threads} \
            -k ${min_seed_length} \
            -I ${sep=',' min_std_max_min+} \
            ${reference} \
            ${sep=' ' reads+} > output.sam
  }
  output {
    File sam = "output.sam"
  }
  runtime {
    docker: "broadinstitute/baseimg"
  }
}

task wc2_tool {
  input {
    File file1
  }
  command {
    wc ${file1}
  }
  output {
    Int count = read_int(stdout())
  }
}

workflow count_lines4_wf {
  input {
    Array[File] files
  }
  scatter(f in files) {
    call wc2_tool {
      input: file1=f
    }
  }
  output {
    wc2_tool.count
  }
}

task tmap_tool {
  input {
    Array[String] stages
    File reads
  }
  command {
    tmap mapall ${sep=' ' stages} < ${reads} > output.sam
  }
  output {
    File sam = "output.sam"
  }
}

workflow wf {
  input {
    Array[File] files
    Int threshold
    Map[String, String] my_map
  }
  call analysis_job {
    input: search_paths = files, threshold = threshold, gender_lookup = my_map
  }
}

workflow w {
  input {
    Int i
    String s
  }
}

workflow foo {
  input {
    Int? x
    File? y
  }
  # ... remaining workflow content
}

workflow foo {
  input {
    Int x = 5
  }
  ...
}

task foo {
  input {
    Int x = 5
  }
  ...
}

workflow foo {
  input {
    Int x = 10
  }
  call my_task as t1 { input: int_in = x }
  Int y = my_task.out
  call my_task as t2 { input: int_in = y }
}

workflow foo {
  input {
    Int x = 10
    Int y = my_task.out
  }

  call my_task as t1 { input: int_in = x }
  call my_task as t2 { input: int_in = y }
}

input {
  String? s = "hello"
}

workflow foo {
  input {
    String? s = "hello"
  }

  call valid { input: s_maybe = s }

  # This would cause a validation error. Cannot use String? for a String input:
  call invalid { input: s_definitely = s }
}

task valid {
  input {
    String? s_maybe
  }
  ...
}

task invalid {
  input {
    String s_definitely
  }
}

import "lib.wdl" as lib
workflow wf {
  call my_task
  call my_task as my_task_alias
  call my_task as my_task_alias2 {
    input: threshold=2
  }
  call lib.other_task
}

task task1 {
  command {
    python do_stuff.py
  }
  output {
    File results = stdout()
  }
}
task task2 {
  input {
    File foobar
  }
  command {
    python do_stuff2.py ${foobar}
  }
  output {
    File results = stdout()
  }
}
workflow wf {
  call task1
  call task2 {
    input: foobar=task1.results
  }
}

workflow foo {
  input {
    # This input `my_task_int_in` is usually based on a task output, unless it's overridden in the input set:
    Int my_task_int_in = some_preliminary_task.int_out
  }

  call some_preliminary_task
  call my_task { input: my_task_int_in = x) }
}

import "sub_wdl.wdl" as sub

workflow main_workflow {

    call sub.wf_hello { input: wf_hello_input = "sub world" }

    output {
        String main_output = wf_hello.salutation
    }
}

task hello {
  input {
    String addressee
  }
  command {
    echo "Hello ${addressee}!"
  }
  runtime {
      docker: "ubuntu:latest"
  }
  output {
    String salutation = read_string(stdout())
  }
}

workflow wf_hello {
  input {
    String wf_hello_input
  }

  call hello {input: addressee = wf_hello_input }

  output {
    String salutation = hello.salutation
  }
}

scatter(i in integers) {
  call task1{input: num=i}
  call task2{input: num=task1.output}
}

workflow foo {
  # Call 'x', producing a Boolean output:
  call x
  Boolean x_out = x.out

  # Call 'y', producing an Int output, in a conditional block:
  if (x_out) {
    call y
    Int y_out = y.out
  }

  # Outside the if block, we have to handle this output as optional:
  Int? y_out_maybe = y.out

  # Call 'z' which takes an optional Int input:
  call z { input: optional_int = y_out_maybe }
}

workflow foo {
  input {
    Array[Int] scatter_range = [1, 2, 3, 4, 5]
  }
  scatter (i in scatter_range) {
    call x { input: i = i }
    if (x.validOutput) {
      Int x_out = x.out
    }
  }

  # Because it was declared inside the scatter and the if-block, the type of x_out is different here:
  Array[Int?] x_out_maybes = x_out

  # We can select only the valid elements with select_all:
  Array[Int] x_out_valids = select_all(x_out_maybes)

  # Or we can select the first valid element:
  Int x_out_first = select_first(x_out_maybes)
}

workflow foo {
  input {
    Boolean b
    Boolean c
  }
  if(b) {
    if(c) {
      call x
      Int x_out = x.out
    }
  }
  Int? x_out_maybe = x_out # Even though it's within two 'if's, we don't need Int??

  # Call 'y' which takes an Int input:
  call y { input: int_input = select_first([x_out_maybe, 5]) } # The select_first produces an Int, not an Int?
}

  parameter_meta {
    memory_mb: "Amount of memory to allocate to the JVM"
    param: "Some arbitrary parameter"
    sample_id: "The ID of the sample in format foo_bar_baz"
  }

  meta {
    author: "Joe Somebody"
    email: "joe@company.org"
  }

task t {
  input {
    Int i
  }
  command {
    # do something
  }
  output {
    String out = "out"
  }
}

workflow w {
  input {
    String w_input = "some input"
  }

  call t
  call t as u

  output {
    String t_out = t.out
    String u_out = u.out
    String input_as_output = w_input
    String previous_output = u_out
  }
}

task t {
  command {
    # do something
  }
  output {
    String out = "out"
  }
}

workflow w {
  input {
    Array[Int] arr = [1, 2]
  }

  scatter(i in arr) {
    call t
  }

  output {
    Array[String] t_out = t.out
  }
}

struct name { ... }

struct Name {
    String myString
    Int myInt
}

struct Invalid {
    String myString = "Cannot do this"
    Int myInt
}

struct Name {
    Array[Array[File]] myFiles
    Map[String,Pair[String,File]] myComplexType
    String cohortName
}

struct Name {
    Array[File]+ myFiles
    Boolean? myBoolean
}

struct Person {
    String name
    Int age
}


task task_a {
    Person a
    command {
        echo "hello my name is ${a.name} and I am ${a.age} years old"
    }
}

workflow myWorkflow {
    Person a
    call task_a {
        input:
            a = a
    }
}


Person a = {"name": "John","age": 30}


struct Experiment {
    Array[File] experimentFiles
    Map[String,String] experimentData
}


workflow workflow_a {
    Experiment myExperiment
    File firstFile = myExperiment.experimentFiles[0]
    String experimentName = myExperiment.experimentData["name"]


}

workflow workflow_a {
    Array[Experiment] myExperiments

    File firstFileFromFirstExperiment = myExperiments[0].experimentFiles[0]
    File eperimentNameFromFirstExperiment = bams[0].experimentData["name"]
    ....
}


import http://example.com/example.wdl as ex alias Experiment as OtherExperiment

import http://example.com/another_exampl.wdl as ex2
    alias Parent as Parent2
    alias Child as Child2
    alias GrandChild as GrandChild2

task x {
  command { python script.py }
}
task y {
  command { python script2.py }
}

import "tasks.wdl" as pyTasks

workflow wf {
  call pyTasks.x
  call pyTasks.y
}

import "tasks.wdl"

workflow wf {
  call tasks.x
  call tasks.y
}

task my_task {
  input {
    Int x
    File f
  }
  command {
    my_cmd --integer=${var} ${f}
  }
}

workflow wf {
  input {
    Array[File] files
    Int x = 2
  }
  scatter(file in files) {
    Int x = 3
    call my_task {
      Int x = 4
      input: var=x, f=file
    }
  }
}

task test {
  input {
    Array[File]  a
    Array[File]+ b
    Array[File]? c
    #File+ d <-- can't do this, + only applies to Arrays
  }
  command {
    /bin/mycmd ${sep=" " a}
    /bin/mycmd ${sep="," b}
    /bin/mycmd ${write_lines(c)}
  }
}

workflow wf {
  call test
}

task test {
  input {
    String? val
  }
  command {
    python script.py --val=${val}
  }
}

task inc {
  input {
    Int i
  }

  command <<<
  python -c "print(~{i} + 1)"
  >>>

  output {
    Int incremented = read_int(stdout())
  }
}

workflow wf {
  Array[Int] integers = [1,2,3,4,5]
  scatter(i in integers) {
    call inc{input: i=i}
  }
}

task inc {
  input {
    Int i
  }

  command <<<
  python -c "print(~{i} + 1)"
  >>>

  output {
    Int incremented = read_int(stdout())
  }
}

task sum {
  input {
    Array[Int] ints
  }
  command <<<
  python -c "print(~{sep="+" ints})"
  >>>
  output {
    Int sum = read_int(stdout())
  }
}

workflow wf {
  Array[Int] integers = [1,2,3,4,5]
  scatter (i in integers) {
    call inc {input: i=i}
  }
  call sum {input: ints = inc.increment}
}

workflow wf {
  input {
    Array[Int] integers = [1,2,3,4,5]
  }
  scatter(i in integers) {
    call inc {input: i=i}
    call inc as inc2 {input: i=inc.incremented}
  }
  call sum {input: ints = inc2.increment}
}

task my_task {
  input {
    Array[String] strings
  }
  command {
    python analyze.py --strings-file=${write_lines(strings)}
  }
}

workflow wf {
  input {
    String s = "wf_s"
    String t = "t"
  }
  call my_task {
    String s = "my_task_s"
    input: in0 = s+"-suffix", in1 = t+"-suffix"
  }
}

task test {
  input {
    Int i
    Float f
  }
  String s = "${i}"

  command {
    ./script.sh -i ${s} -f ${f}
  }
}

task t1 {
  input {
    String s
    Int x
  }

  command {
    ./script --action=${s} -x${x}
  }
  output {
    Int count = read_int(stdout())
  }
}

task t2 {
  input {
    String s
    Int t
    Int x
  }

  command {
    ./script2 --action=${s} -x${x} --other=${t}
  }
  output {
    Int count = read_int(stdout())
  }
}

task t3 {
  input {
    Int y
    File ref_file # Do nothing with this
  }

  command {
    python -c "print(${y} + 1)"
  }
  output {
    Int incr = read_int(stdout())
  }
}

workflow wf {
  input {
    Int int_val
    Int int_val2 = 10
    Array[Int] my_ints
    File ref_file
  }

  String not_an_input = "hello"

  call t1 {
    input: x = int_val
  }
  call t2 {
    input: x = int_val, t=t1.count
  }
  scatter(i in my_ints) {
    call t3 {
      input: y=i, ref=ref_file
    }
  }
}

task do_stuff {
  input {
    String pattern
    File file
  }
  command {
    grep '${pattern}' ${file}
  }
  output {
    Array[String] matches = read_lines(stdout())
  }
}

task do_stuff {
  input {
    File file
  }
  command {
    python do_stuff.py ${file}
  }
  output {
    Array[Array[String]] output_table = read_tsv("./results/file_list.tsv")
  }
}

task do_stuff {
  input {
    String flags
    File file
  }
  command {
    ./script --flags=${flags} ${file}
  }
  output {
    Map[String, String] mapping = read_map(stdout())
  }
}

task test {
  command <<<
    python <<CODE
    print('\t'.join(["key_{}".format(i) for i in range(3)]))
    print('\t'.join(["value_{}".format(i) for i in range(3)]))
    CODE
  >>>
  output {
    Object my_obj = read_object(stdout())
  }
}

task test {
  command <<<
    python <<CODE
    print('\t'.join(["key_{}".format(i) for i in range(3)]))
    print('\t'.join(["value_{}".format(i) for i in range(3)]))
    print('\t'.join(["value_{}".format(i) for i in range(3)]))
    print('\t'.join(["value_{}".format(i) for i in range(3)]))
    CODE
  >>>
  output {
    Array[Object] my_obj = read_objects(stdout())
  }
}

task do_stuff {
  input {
    File file
  }
  command {
    python do_stuff.py ${file}
  }
  output {
    Map[String, String] output_table = read_json("./results/file_list.json")
  }
}

task example {
  Array[String] array = ["first", "second", "third"]
  command {
    ./script --file-list=${write_lines(array)}
  }
}

task example {
  Array[String] array = [["one", "two", "three"], ["un", "deux", "trois"]]
  command {
    ./script --tsv=${write_tsv(array)}
  }
}

task example {
  Map[String, String] map = {"key1": "value1", "key2": "value2"}
  command {
    ./script --map=${write_map(map)}
  }
}

task test {
  Object input
  command <<<
    /bin/do_work --obj=~{write_object(input)}
  >>>
  output {
    File results = stdout()
  }
}

task test {
  input {
    Array[Object] in
  }
  command <<<
    /bin/do_work --obj=~{write_objects(in)}
  >>>
  output {
    File results = stdout()
  }
}

task example {
  input {
    Map[String, String] map = {"key1": "value1", "key2": "value2"}
  }
  command {
    ./script --map=${write_json(map)}
  }
}

task example {
  input {
    File input_file
  }

  command {
    echo "this file is 22 bytes" > created_file
  }

  output {
    Float input_file_size = size(input_file)
    Float created_file_size = size("created_file") # 22.0
    Float created_file_size_in_KB = size("created_file", "K") # 0.022
  }
}

  String chocolike = "I like chocolate when it's late"

  String chocolove = sub(chocolike, "like", "love") # I love chocolate when it's late
  String chocoearly = sub(chocolike, "late", "early") # I like chocoearly when it's early
  String chocolate = sub(chocolike, "late$", "early") # I like chocolate when it's early
}

task example {
  input {
    File input_file = "my_input_file.bam"
    String output_file_name = sub(input_file, "\\.bam$", ".index") # my_input_file.index
  }
  command {
    echo "I want an index instead" > ${output_file_name}
  }

  output {
    File outputFile = output_file_name
  }
}

Pair[Int, String] p = (0, "z")
Array[Int] xs = [ 1, 2, 3 ]
Array[String] ys = [ "a", "b", "c" ]
Array[String] zs = [ "d", "e" ]

Array[Pair[Int, String]] zipped = zip(xs, ys)     # i.e.  zipped = [ (1, "a"), (2, "b"), (3, "c") ]

Pair[Int, String] p = (0, "z")
Array[Int] xs = [ 1, 2, 3 ]
Array[String] ys = [ "a", "b", "c" ]
Array[String] zs = [ "d", "e" ]

Array[Pair[Int, String]] crossed = cross(xs, zs) # i.e. crossed = [ (1, "d"), (1, "e"), (2, "d"), (2, "e"), (3, "d"), (3, "e") ]

Array[Int] xs = [ 1, 2, 3 ]
Array[String] ys = [ "a", "b", "c" ]
Array[String] zs = [ ]

Integer xlen = length(xs) # 3
Integer ylen = length(ys) # 3
Integer zlen = length(zs) # 0

Array[Array[Integer]] ai2D = [[1, 2, 3], [1], [21, 22]]
Array[Integer] ai = flatten(ai2D)   # [1, 2, 3, 1, 21, 22]

Array[Array[File]] af2D = [["/tmp/X.txt"], ["/tmp/Y.txt", "/tmp/Z.txt"], []]
Array[File] af = flatten(af2D)   # ["/tmp/X.txt", "/tmp/Y.txt", "/tmp/Z.txt"]

Array[Array[Pair[Float,String]]] aap2D = [[(0.1, "mouse")], [(3, "cat"), (15, "dog")]]

Array[Pair[Float,String]] ap = flatten(aap2D) # [(0.1, "mouse"), (3, "cat"), (15, "dog")]

Array[String] env = ["key1=value1", "key2=value2", "key3=value3"]
Array[String] env_param = prefix("-e ", env) # ["-e key1=value1", "-e key2=value2", "-e key3=value3"]

Array[Integer] env2 = [1, 2, 3]
Array[String] env2_param = prefix("-f ", env2) # ["-f 1", "-f 2", "-f 3"]

task test {
  input {
    Array[File] files
  }
  command {
    Rscript analysis.R --files=${sep=',' files}
  }
  output {
    Array[String] strs = read_lines(stdout())
  }
}

task output_example {
  input {
    String s
    Int i
    Float f
  }

  command {
    python do_work.py ${s} ${i} ${f}
  }
}

task test {
  input {
    Array[File] bams
  }
  command {
    python script.py --bams=${sep=',' bams}
  }
}

task test {
  input {
    Array[File] bams
  }
  command {
    sh script.sh ${write_lines(bams)}
  }
}

task test {
  input {
    Array[File] bams
  }
  command {
    sh script.sh ${write_json(bams)}
  }
}

task test {
  input {
    Map[String, Float] sample_quality_scores
  }
  command {
    sh script.sh ${write_map(sample_quality_scores)}
  }
}

task test {
  input {
    Map[String, Float] sample_quality_scores
  }
  command {
    sh script.sh ${write_json(sample_quality_scores)}
  }
}

task test {
  input {
    Object sample
  }
  command {
    perl script.pl ${write_object(sample)}
  }
}

task test {
  input {
    Object sample
  }
  command {
    perl script.pl ${write_json(sample)}
  }
}

task test {
  input {
    Array[Object] sample
  }
  command {
    perl script.pl ${write_objects(sample)}
  }
}

task test {
  input {
    Array[Object] sample
  }
  command {
    perl script.pl ${write_json(sample)}
  }
}

task output_example {
  input {
    String param1
    String param2
  }
  command {
    python do_work.py ${param1} ${param2} --out1=int_file --out2=str_file
  }
  output {
    Int my_int = read_int("int_file")
    String my_str = read_string("str_file")
  }
}

task test {
  command <<<
    python <<CODE
    import random
    for i in range(10):
      print(random.randrange(10))
    CODE
  >>>
  output {
    Array[Int] my_ints = read_lines(stdout())
  }
}

task test {
  command <<<
    echo '["foo", "bar"]'
  >>>
  output {
    Array[String] my_array = read_json(stdout())
  }
}

task test {
  command <<<
    python <<CODE
    for i in range(3):
      print("key_{idx}\t{idx}".format(idx=i)
    CODE
  >>>
  output {
    Map[String, Int] my_ints = read_map(stdout())
  }
}

task test {
  command <<<
    echo '{"foo":"bar"}'
  >>>
  output {
    Map[String, String] my_map = read_json(stdout())
  }
}

task test {
  command <<<
    python <<CODE
    print('\t'.join(["key_{}".format(i) for i in range(3)]))
    print('\t'.join(["value_{}".format(i) for i in range(3)]))
    CODE
  >>>
  output {
    Object my_obj = read_object(stdout())
  }
}

task test {
  command <<<
    python <<CODE
    print('\t'.join(["key_{}".format(i) for i in range(3)]))
    print('\t'.join(["value_{}".format(i) for i in range(3)]))
    print('\t'.join(["value_{}".format(i) for i in range(3)]))
    print('\t'.join(["value_{}".format(i) for i in range(3)]))
    CODE
  >>>
  output {
    Array[Object] my_obj = read_objects(stdout())
  }
}

