; LLVM IR generated by Intel SYCL Clang compiler (https://github.com/intel/llvm)
; SYCL source code can be found below:

; #include <CL/sycl.hpp>
; #include <CL/sycl/intel/fpga_extensions.hpp>
;
; int main() {
;   cl::sycl::queue Queue{cl::sycl::intel::fpga_emulator_selector{}};
;
;   {
;     cl::sycl::buffer<int, 1> output_buffer(output_data, 1);
;     cl::sycl::buffer<int, 1> input_buffer(input_data, 1);
;
;     Queue.submit([&](cl::sycl::handler &cgh) {
;       auto output_accessor =
;           output_buffer.get_access<cl::sycl::access::mode::write>(cgh);
;       auto input_accessor =
;           input_buffer.get_access<cl::sycl::access::mode::read>(cgh);
;
;       cgh.single_task<class kernel>([=] {
;         auto input_ptr = input_accessor.get_pointer();
;         auto output_ptr = output_accessor.get_pointer();
;
;         using PrefetchingLSU =
;             cl::sycl::intel::lsu<cl::sycl::intel::prefetch<true>,
;                                  cl::sycl::intel::statically_coalesce<false>>;
;
;         using BurstCoalescedLSU =
;             cl::sycl::intel::lsu<cl::sycl::intel::burst_coalesce<true>,
;                                  cl::sycl::intel::statically_coalesce<false>>;
;
;         using CachingLSU =
;             cl::sycl::intel::lsu<cl::sycl::intel::burst_coalesce<true>,
;                                  cl::sycl::intel::cache<1024>,
;                                  cl::sycl::intel::statically_coalesce<false>>;
;
;         using PipelinedLSU = cl::sycl::intel::lsu<>;
;
;         int X = PrefetchingLSU::load(input_ptr); // int X = input_ptr[0]
;         int Y = CachingLSU::load(input_ptr + 1); // int Y = input_ptr[1]
;
;         BurstCoalescedLSU::store(output_ptr, X); // output_ptr[0] = X
;         PipelinedLSU::store(output_ptr + 1, Y);  // output_ptr[1] = Y
;       });
;     });
;   }
;
;   return 0;
; }

; Check that translation of optimized IR doesn't crash:
; RUN: llvm-as %s -o %t.bc
; RUN: llvm-spirv %t.bc --spirv-ext=+SPV_INTEL_fpga_memory_accesses -o %t.spv

; Check that reverse translation restore ptr.annotations correctly:
; RUN: llvm-spirv -r %t.spv -o %t.rev.bc
; RUN: llvm-dis < %t.rev.bc | FileCheck %s --check-prefix=CHECK-LLVM

target datalayout = "e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-n8:16:32:64"
target triple = "spir64-unknown-unknown-sycldevice"

%"class._ZTSN2cl4sycl5rangeILi1EEE.cl::sycl::range" = type { %"class._ZTSN2cl4sycl6detail5arrayILi1EEE.cl::sycl::detail::array" }
%"class._ZTSN2cl4sycl6detail5arrayILi1EEE.cl::sycl::detail::array" = type { [1 x i64] }

$"_ZTSZZ8test_lsuN2cl4sycl5queueEENK3$_0clERNS0_7handlerEE6kernel" = comdat any

@.str = private unnamed_addr constant [26 x i8] c"{params:12}{cache-size:0}\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [14 x i8] c"<invalid loc>\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [28 x i8] c"{params:7}{cache-size:1024}\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [25 x i8] c"{params:5}{cache-size:0}\00", section "llvm.metadata"
@.str.4 = private unnamed_addr constant [25 x i8] c"{params:0}{cache-size:0}\00", section "llvm.metadata"

; CHECK-LLVM: [[PTR_i27_ANNOT_STR:@[a-z0-9_.]]] = {{.*}}{params:12}
; CHECK-LLVM: [[PTR_i15_i_ANNOT_STR:@[a-z0-9_.]]] = {{.*}}{params:7}{cache-size:1024}
; CHECK-LLVM: [[PTR_i_ANNOT_STR:@[a-z0-9_.]]] = {{.*}}{params:5}
; CHECK-LLVM: [[PTR_i_i_ANNOT_STR:@[a-z0-9_.]]] = {{.*}}{params:0}{cache-size:0}

; Function Attrs: norecurse
define weak_odr dso_local spir_kernel void @"_ZTSZZ8test_lsuN2cl4sycl5queueEENK3$_0clERNS0_7handlerEE6kernel"(i32 addrspace(1)* %_arg_, %"class._ZTSN2cl4sycl5rangeILi1EEE.cl::sycl::range"* byval(%"class._ZTSN2cl4sycl5rangeILi1EEE.cl::sycl::range") align 8 %_arg_1, %"class._ZTSN2cl4sycl5rangeILi1EEE.cl::sycl::range"* byval(%"class._ZTSN2cl4sycl5rangeILi1EEE.cl::sycl::range") align 8 %_arg_2, %"class._ZTSN2cl4sycl5rangeILi1EEE.cl::sycl::range"* byval(%"class._ZTSN2cl4sycl5rangeILi1EEE.cl::sycl::range") align 8 %_arg_3, i32 addrspace(1)* %_arg_4, %"class._ZTSN2cl4sycl5rangeILi1EEE.cl::sycl::range"* byval(%"class._ZTSN2cl4sycl5rangeILi1EEE.cl::sycl::range") align 8 %_arg_6, %"class._ZTSN2cl4sycl5rangeILi1EEE.cl::sycl::range"* byval(%"class._ZTSN2cl4sycl5rangeILi1EEE.cl::sycl::range") align 8 %_arg_7, %"class._ZTSN2cl4sycl5rangeILi1EEE.cl::sycl::range"* byval(%"class._ZTSN2cl4sycl5rangeILi1EEE.cl::sycl::range") align 8 %_arg_8) local_unnamed_addr #0 comdat !kernel_arg_addr_space !4 !kernel_arg_access_qual !5 !kernel_arg_type !6 !kernel_arg_base_type !6 !kernel_arg_type_qual !7 !kernel_arg_buffer_location !8 {
entry:
  %0 = getelementptr inbounds %"class._ZTSN2cl4sycl5rangeILi1EEE.cl::sycl::range", %"class._ZTSN2cl4sycl5rangeILi1EEE.cl::sycl::range"* %_arg_3, i64 0, i32 0, i32 0, i64 0
  %1 = load i64, i64* %0, align 8
  %add.ptr.i27 = getelementptr inbounds i32, i32 addrspace(1)* %_arg_, i64 %1
  %2 = getelementptr inbounds %"class._ZTSN2cl4sycl5rangeILi1EEE.cl::sycl::range", %"class._ZTSN2cl4sycl5rangeILi1EEE.cl::sycl::range"* %_arg_8, i64 0, i32 0, i32 0, i64 0
  %3 = load i64, i64* %2, align 8
  %add.ptr.i = getelementptr inbounds i32, i32 addrspace(1)* %_arg_4, i64 %3
  %4 = addrspacecast i32 addrspace(1)* %add.ptr.i27 to i32 addrspace(4)*
  %5 = tail call dereferenceable(4) i32 addrspace(4)* @llvm.ptr.annotation.p4i32(i32 addrspace(4)* %4, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.1, i64 0, i64 0), i32 0, i8* null) #2
  %6 = load i32, i32 addrspace(4)* %5, align 4, !tbaa !9
  ; CHECK-LLVM: [[PTR_i27:[%0-9a-z.]+]] = getelementptr inbounds i32, i32 addrspace(1)* {{[%0-9a-z._]+}}, i64 {{[%0-9a-z.]+}}
  ; CHECK-LLVM: [[PTR_i:[%0-9a-z.]+]] = getelementptr inbounds i32, i32 addrspace(1)* {{[%0-9a-z._]+}}, i64 {{[%0-9a-z.]+}}
  ; CHECK-LLVM: [[PTR_i27_AS_CAST:[%0-9a-z.]+]] = addrspacecast i32 addrspace(1)* [[PTR_i27]] to i32 addrspace(4)*
  ; CHECK-LLVM: [[PTR_ANNOT_CALL:[%0-9a-z.]+]] = call i32 addrspace(4)* @llvm.ptr.annotation.p4i32(i32 addrspace(4)* [[PTR_i27_AS_CAST]], i8* getelementptr inbounds ({{.*}} [[PTR_i27_ANNOT_STR]]
  ; CHECK-LLVM: [[PTR_RESULT_LOAD:[%0-9a-z.]+]] = load i32, i32 addrspace(4)* [[PTR_ANNOT_CALL]]
  %add.ptr.i15.i = getelementptr inbounds i32, i32 addrspace(1)* %add.ptr.i27, i64 1
  %7 = addrspacecast i32 addrspace(1)* %add.ptr.i15.i to i32 addrspace(4)*
  %8 = tail call dereferenceable(4) i32 addrspace(4)* @llvm.ptr.annotation.p4i32(i32 addrspace(4)* %7, i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.2, i64 0, i64 0), i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.1, i64 0, i64 0), i32 0, i8* null) #2
  %9 = load i32, i32 addrspace(4)* %8, align 4, !tbaa !9
  ; CHECK-LLVM: [[PTR_i15_i:[%0-9a-z.]+]] = getelementptr inbounds i32, i32 addrspace(1)* {{[%0-9a-z._]+}}, i64 {{[%0-9a-z.]+}}
  ; CHECK-LLVM: [[PTR_i15_i_AS_CAST:[%0-9a-z.]+]] = addrspacecast i32 addrspace(1)* [[PTR_i15_i]] to i32 addrspace(4)*
  ; CHECK-LLVM: [[PTR_ANNOT_CALL:[%0-9a-z.]+]] = call i32 addrspace(4)* @llvm.ptr.annotation.p4i32(i32 addrspace(4)* [[PTR_i15_i_AS_CAST]], i8* getelementptr inbounds ({{.*}} [[PTR_i15_i_ANNOT_STR]]
  ; CHECK-LLVM: [[PTR_RESULT_LOAD_1:[%0-9a-z.]+]] = load i32, i32 addrspace(4)* [[PTR_ANNOT_CALL]]
  %10 = addrspacecast i32 addrspace(1)* %add.ptr.i to i32 addrspace(4)*
  %11 = tail call i32 addrspace(4)* @llvm.ptr.annotation.p4i32(i32 addrspace(4)* %10, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.3, i64 0, i64 0), i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.1, i64 0, i64 0), i32 0, i8* null) #2
  store i32 %6, i32 addrspace(4)* %11, align 4, !tbaa !9
  ; CHECK-LLVM: [[PTR_i_AS_CAST:[%0-9a-z.]+]] = addrspacecast i32 addrspace(1)* [[PTR_i]] to i32 addrspace(4)*
  ; CHECK-LLVM: [[PTR_ANNOT_CALL:[%0-9a-z.]+]] = call i32 addrspace(4)* @llvm.ptr.annotation.p4i32(i32 addrspace(4)* [[PTR_i_AS_CAST]], i8* getelementptr inbounds ({{.*}} [[PTR_i_ANNOT_STR]]
  ; CHECK-LLVM: store i32 [[PTR_RESULT_LOAD]], i32 addrspace(4)* [[PTR_ANNOT_CALL]]
  %add.ptr.i.i = getelementptr inbounds i32, i32 addrspace(1)* %add.ptr.i, i64 1
  %12 = addrspacecast i32 addrspace(1)* %add.ptr.i.i to i32 addrspace(4)*
  %13 = tail call i32 addrspace(4)* @llvm.ptr.annotation.p4i32(i32 addrspace(4)* %12, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.4, i64 0, i64 0), i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.1, i64 0, i64 0), i32 0, i8* null) #2
  store i32 %9, i32 addrspace(4)* %13, align 4, !tbaa !9
  ; CHECK-LLVM: [[PTR_i_i:[%0-9a-z.]+]] = getelementptr inbounds i32, i32 addrspace(1)* {{[%0-9a-z._]+}}, i64 {{[%0-9a-z.]+}}
  ; CHECK-LLVM: [[PTR_i_i_AS_CAST:[%0-9a-z.]+]] = addrspacecast i32 addrspace(1)* [[PTR_i_i]] to i32 addrspace(4)*
  ; CHECK-LLVM: [[PTR_ANNOT_CALL:[%0-9a-z.]+]] = call i32 addrspace(4)* @llvm.ptr.annotation.p4i32(i32 addrspace(4)* [[PTR_i_i_AS_CAST]], i8* getelementptr inbounds ({{.*}} [[PTR_i_i_ANNOT_STR]]
  ; CHECK-LLVM: store i32 [[PTR_RESULT_LOAD_1]], i32 addrspace(4)* [[PTR_ANNOT_CALL]]
  ret void
}

; Function Attrs: nounwind willreturn
declare i32 addrspace(4)* @llvm.ptr.annotation.p4i32(i32 addrspace(4)*, i8*, i8*, i32, i8*) #1

attributes #0 = { norecurse "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "sycl-module-id"="fpga_lsu.cpp" "uniform-work-group-size"="true" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind willreturn }
attributes #2 = { nounwind readnone }

!opencl.spir.version = !{!0}
!spirv.Source = !{!1}
!llvm.ident = !{!2}
!llvm.module.flags = !{!3}

!0 = !{i32 1, i32 2}
!1 = !{i32 4, i32 100000}
!2 = !{!"clang version 12.0.0"}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{i32 1, i32 0, i32 0, i32 0, i32 1, i32 0, i32 0, i32 0}
!5 = !{!"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none"}
!6 = !{!"int*", !"cl::sycl::range<1>", !"cl::sycl::range<1>", !"cl::sycl::id<1>", !"int*", !"cl::sycl::range<1>", !"cl::sycl::range<1>", !"cl::sycl::id<1>"}
!7 = !{!"", !"", !"", !"", !"", !"", !"", !""}
!8 = !{i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1}
!9 = !{!10, !10, i64 0}
!10 = !{!"int", !11, i64 0}
!11 = !{!"omnipotent char", !12, i64 0}
!12 = !{!"Simple C++ TBAA"}
