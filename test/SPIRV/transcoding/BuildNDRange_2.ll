; RUN: llvm-as %s -o %t.bc
; RUN: llvm-spirv %t.bc -spirv-text -o %t.spv.txt
; RUN: FileCheck < %t.spv.txt %s --check-prefix=CHECK-SPIRV
; RUN: llvm-spirv %t.bc -o %t.spv
; RUN: llvm-spirv -r %t.spv -o %t.rev.bc
; RUN: llvm-dis %t.rev.bc
; RUN: FileCheck < %t.rev.ll %s --check-prefix=CHECK-LLVM

; CHECK-SPIRV-DAG: BuildNDRange {{[0-9]+}} {{[0-9]+}} [[GWS:[0-9]+]] [[LWS:[0-9]+]] [[GWO:[0-9]+]]
; CHECK-SPIRV-DAG: BuildNDRange {{[0-9]+}} {{[0-9]+}} [[GWS:[0-9]+]] [[LWS:[0-9]+]] [[GWO:[0-9]+]]
; CHECK-SPIRV-DAG: BuildNDRange {{[0-9]+}} {{[0-9]+}} [[GWS:[0-9]+]] [[LWS:[0-9]+]] [[GWO:[0-9]+]]

; CHECK-LLVM: call spir_func void @_Z10ndrange_1Djjj(%struct.ndrange_t* %ndrange,
; CHECK-LLVM: call spir_func void @_Z10ndrange_2D
; CHECK-LLVM: call spir_func void @_Z10ndrange_3D

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

%opencl.queue_t = type opaque
%opencl.block = type opaque
%struct.ndrange_t = type <{ i32, [3 x i64], [3 x i64], [3 x i64] }>

@block_fn.gs = internal constant [2 x i32] [i32 64, i32 4096], align 4
@block_fn.gs1 = internal constant [3 x i32] [i32 64, i32 64, i32 64], align 4

; Function Attrs: nounwind
define spir_func void @block_fn(i32 %level, i32 %maxGlobalWorkSize, i32 addrspace(1)* %rnd, i32 addrspace(1)* %res) #0 {
entry:
  %level.addr = alloca i32, align 4
  %maxGlobalWorkSize.addr = alloca i32, align 4
  %rnd.addr = alloca i32 addrspace(1)*, align 4
  %res.addr = alloca i32 addrspace(1)*, align 4
  %tidX = alloca i32, align 4
  %tidY = alloca i32, align 4
  %tidZ = alloca i32, align 4
  %linearId = alloca i32, align 4
  %def_q = alloca %opencl.queue_t*, align 4
  %kernelBlock = alloca %opencl.block*, align 4
  %captured = alloca <{ i32, i32, i32 addrspace(1)*, i32 addrspace(1)* }>, align 4
  %wg = alloca i32, align 4
  %ndrange = alloca %struct.ndrange_t, align 1
  %gs = alloca i32, align 4
  %ls = alloca i32, align 4
  %tmp = alloca %struct.ndrange_t, align 1
  %ls14 = alloca [2 x i32], align 4
  %tmp27 = alloca %struct.ndrange_t, align 1
  %ls30 = alloca [3 x i32], align 4
  %tmp47 = alloca %struct.ndrange_t, align 1
  %enq_res = alloca i32, align 4
  store i32 %level, i32* %level.addr, align 4
  store i32 %maxGlobalWorkSize, i32* %maxGlobalWorkSize.addr, align 4
  store i32 addrspace(1)* %rnd, i32 addrspace(1)** %rnd.addr, align 4
  store i32 addrspace(1)* %res, i32 addrspace(1)** %res.addr, align 4
  %call = call spir_func i32 @_Z13get_global_idj(i32 0)
  store i32 %call, i32* %tidX, align 4
  %call1 = call spir_func i32 @_Z13get_global_idj(i32 1)
  store i32 %call1, i32* %tidY, align 4
  %call2 = call spir_func i32 @_Z13get_global_idj(i32 2)
  store i32 %call2, i32* %tidZ, align 4
  %call3 = call spir_func i32 @_Z20get_global_linear_idv()
  store i32 %call3, i32* %linearId, align 4
  %call4 = call spir_func %opencl.queue_t* @get_default_queue()
  store %opencl.queue_t* %call4, %opencl.queue_t** %def_q, align 4
  %0 = load i32* %level.addr, align 4
  %dec = add nsw i32 %0, -1
  store i32 %dec, i32* %level.addr, align 4
  %cmp = icmp slt i32 %dec, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %if.end68

if.end:                                           ; preds = %entry
  %block.captured = getelementptr inbounds <{ i32, i32, i32 addrspace(1)*, i32 addrspace(1)* }>* %captured, i32 0, i32 0
  %1 = load i32* %level.addr, align 4
  store i32 %1, i32* %block.captured, align 4
  %block.captured5 = getelementptr inbounds <{ i32, i32, i32 addrspace(1)*, i32 addrspace(1)* }>* %captured, i32 0, i32 1
  %2 = load i32* %maxGlobalWorkSize.addr, align 4
  store i32 %2, i32* %block.captured5, align 4
  %block.captured6 = getelementptr inbounds <{ i32, i32, i32 addrspace(1)*, i32 addrspace(1)* }>* %captured, i32 0, i32 2
  %3 = load i32 addrspace(1)** %rnd.addr, align 4
  store i32 addrspace(1)* %3, i32 addrspace(1)** %block.captured6, align 4
  %block.captured7 = getelementptr inbounds <{ i32, i32, i32 addrspace(1)*, i32 addrspace(1)* }>* %captured, i32 0, i32 3
  %4 = load i32 addrspace(1)** %res.addr, align 4
  store i32 addrspace(1)* %4, i32 addrspace(1)** %block.captured7, align 4
  %5 = bitcast <{ i32, i32, i32 addrspace(1)*, i32 addrspace(1)* }>* %captured to i8*
  %6 = call %opencl.block* @spir_block_bind(i8* bitcast (void (i8*)* @__block_fn_block_invoke to i8*), i32 16, i32 4, i8* %5)
  store %opencl.block* %6, %opencl.block** %kernelBlock, align 4
  %7 = load %opencl.block** %kernelBlock, align 4
  %call8 = call spir_func i32 @_Z26get_kernel_work_group_sizeU13block_pointerFvvE(%opencl.block* %7)
  store i32 %call8, i32* %wg, align 4
  %8 = load i32* %linearId, align 4
  %9 = load i32* %level.addr, align 4
  %add = add i32 %8, %9
  %rem = urem i32 %add, 3
  switch i32 %rem, label %sw.default [
    i32 0, label %sw.bb
    i32 1, label %sw.bb12
    i32 2, label %sw.bb28
  ]

sw.bb:                                            ; preds = %if.end
  store i32 262144, i32* %gs, align 4
  %10 = load i32* %tidX, align 4
  %11 = load i32* %maxGlobalWorkSize.addr, align 4
  %rem9 = urem i32 %10, %11
  %12 = load i32 addrspace(1)** %rnd.addr, align 4
  %arrayidx = getelementptr inbounds i32 addrspace(1)* %12, i32 %rem9
  %13 = load i32 addrspace(1)* %arrayidx, align 4
  %14 = load i32* %wg, align 4
  %rem10 = urem i32 %13, %14
  %rem11 = urem i32 %rem10, 262144
  store i32 %rem11, i32* %ls, align 4
  %15 = load i32* %ls, align 4
  %tobool = icmp ne i32 %15, 0
  br i1 %tobool, label %cond.true, label %cond.false

cond.true:                                        ; preds = %sw.bb
  %16 = load i32* %ls, align 4
  br label %cond.end

cond.false:                                       ; preds = %sw.bb
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ %16, %cond.true ], [ 1, %cond.false ]
  store i32 %cond, i32* %ls, align 4
  %17 = load i32* %ls, align 4
  call spir_func void @_Z10ndrange_1Djj(%struct.ndrange_t* sret %tmp, i32 262144, i32 %17)
  %18 = bitcast %struct.ndrange_t* %ndrange to i8*
  %19 = bitcast %struct.ndrange_t* %tmp to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %18, i8* %19, i32 76, i32 1, i1 false)
  br label %sw.epilog

sw.bb12:                                          ; preds = %if.end
  %arrayinit.begin = getelementptr inbounds [2 x i32]* %ls14, i32 0, i32 0
  store i32 1, i32* %arrayinit.begin
  %arrayinit.element = getelementptr inbounds i32* %arrayinit.begin, i32 1
  %20 = load i32* %tidY, align 4
  %21 = load i32* %maxGlobalWorkSize.addr, align 4
  %rem15 = urem i32 %20, %21
  %22 = load i32 addrspace(1)** %rnd.addr, align 4
  %arrayidx16 = getelementptr inbounds i32 addrspace(1)* %22, i32 %rem15
  %23 = load i32 addrspace(1)* %arrayidx16, align 4
  %24 = load i32* %wg, align 4
  %rem17 = urem i32 %23, %24
  %25 = load i32* getelementptr inbounds ([2 x i32]* @block_fn.gs, i32 0, i32 1), align 4
  %rem18 = urem i32 %rem17, %25
  store i32 %rem18, i32* %arrayinit.element
  %arrayidx19 = getelementptr inbounds [2 x i32]* %ls14, i32 0, i32 1
  %26 = load i32* %arrayidx19, align 4
  %tobool20 = icmp ne i32 %26, 0
  br i1 %tobool20, label %cond.true21, label %cond.false23

cond.true21:                                      ; preds = %sw.bb12
  %arrayidx22 = getelementptr inbounds [2 x i32]* %ls14, i32 0, i32 1
  %27 = load i32* %arrayidx22, align 4
  br label %cond.end24

cond.false23:                                     ; preds = %sw.bb12
  br label %cond.end24

cond.end24:                                       ; preds = %cond.false23, %cond.true21
  %cond25 = phi i32 [ %27, %cond.true21 ], [ 1, %cond.false23 ]
  %arrayidx26 = getelementptr inbounds [2 x i32]* %ls14, i32 0, i32 1
  store i32 %cond25, i32* %arrayidx26, align 4
  %arraydecay = getelementptr inbounds [2 x i32]* %ls14, i32 0, i32 0
  call spir_func void @_Z10ndrange_2DPKjS0_(%struct.ndrange_t* sret %tmp27, i32* getelementptr inbounds ([2 x i32]* @block_fn.gs, i32 0, i32 0), i32* %arraydecay)
  %28 = bitcast %struct.ndrange_t* %ndrange to i8*
  %29 = bitcast %struct.ndrange_t* %tmp27 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %28, i8* %29, i32 76, i32 1, i1 false)
  br label %sw.epilog

sw.bb28:                                          ; preds = %if.end
  %arrayinit.begin31 = getelementptr inbounds [3 x i32]* %ls30, i32 0, i32 0
  store i32 1, i32* %arrayinit.begin31
  %arrayinit.element32 = getelementptr inbounds i32* %arrayinit.begin31, i32 1
  store i32 1, i32* %arrayinit.element32
  %arrayinit.element33 = getelementptr inbounds i32* %arrayinit.element32, i32 1
  %30 = load i32* %tidZ, align 4
  %31 = load i32* %maxGlobalWorkSize.addr, align 4
  %rem34 = urem i32 %30, %31
  %32 = load i32 addrspace(1)** %rnd.addr, align 4
  %arrayidx35 = getelementptr inbounds i32 addrspace(1)* %32, i32 %rem34
  %33 = load i32 addrspace(1)* %arrayidx35, align 4
  %34 = load i32* %wg, align 4
  %rem36 = urem i32 %33, %34
  %35 = load i32* getelementptr inbounds ([3 x i32]* @block_fn.gs1, i32 0, i32 2), align 4
  %rem37 = urem i32 %rem36, %35
  store i32 %rem37, i32* %arrayinit.element33
  %arrayidx38 = getelementptr inbounds [3 x i32]* %ls30, i32 0, i32 2
  %36 = load i32* %arrayidx38, align 4
  %tobool39 = icmp ne i32 %36, 0
  br i1 %tobool39, label %cond.true40, label %cond.false42

cond.true40:                                      ; preds = %sw.bb28
  %arrayidx41 = getelementptr inbounds [3 x i32]* %ls30, i32 0, i32 2
  %37 = load i32* %arrayidx41, align 4
  br label %cond.end43

cond.false42:                                     ; preds = %sw.bb28
  br label %cond.end43

cond.end43:                                       ; preds = %cond.false42, %cond.true40
  %cond44 = phi i32 [ %37, %cond.true40 ], [ 1, %cond.false42 ]
  %arrayidx45 = getelementptr inbounds [3 x i32]* %ls30, i32 0, i32 2
  store i32 %cond44, i32* %arrayidx45, align 4
  %arraydecay46 = getelementptr inbounds [3 x i32]* %ls30, i32 0, i32 0
  call spir_func void @_Z10ndrange_3DPKjS0_(%struct.ndrange_t* sret %tmp47, i32* getelementptr inbounds ([3 x i32]* @block_fn.gs1, i32 0, i32 0), i32* %arraydecay46)
  %38 = bitcast %struct.ndrange_t* %ndrange to i8*
  %39 = bitcast %struct.ndrange_t* %tmp47 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %38, i8* %39, i32 76, i32 1, i1 false)
  br label %sw.epilog

sw.default:                                       ; preds = %if.end
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.default, %cond.end43, %cond.end24, %cond.end
  %40 = load i32* %tidX, align 4
  %cmp48 = icmp eq i32 %40, 0
  br i1 %cmp48, label %land.lhs.true, label %if.end68

land.lhs.true:                                    ; preds = %sw.epilog
  %41 = load i32* %tidY, align 4
  %cmp49 = icmp eq i32 %41, 0
  br i1 %cmp49, label %land.lhs.true52, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %land.lhs.true
  %call50 = call spir_func i32 @_Z15get_global_sizej(i32 1)
  %cmp51 = icmp eq i32 %call50, 1
  br i1 %cmp51, label %land.lhs.true52, label %if.end68

land.lhs.true52:                                  ; preds = %lor.lhs.false, %land.lhs.true
  %42 = load i32* %tidZ, align 4
  %cmp53 = icmp eq i32 %42, 0
  br i1 %cmp53, label %if.then57, label %lor.lhs.false54

lor.lhs.false54:                                  ; preds = %land.lhs.true52
  %call55 = call spir_func i32 @_Z15get_global_sizej(i32 2)
  %cmp56 = icmp eq i32 %call55, 1
  br i1 %cmp56, label %if.then57, label %if.end68

if.then57:                                        ; preds = %lor.lhs.false54, %land.lhs.true52
  %43 = load i32* %linearId, align 4
  %44 = load i32* %maxGlobalWorkSize.addr, align 4
  %rem58 = urem i32 %43, %44
  %45 = load i32 addrspace(1)** %res.addr, align 4
  %arrayidx59 = getelementptr inbounds i32 addrspace(1)* %45, i32 %rem58
  %call60 = call spir_func i32 @_Z10atomic_incPVU3AS1i(i32 addrspace(1)* %arrayidx59)
  %46 = load %opencl.queue_t** %def_q, align 4
  %47 = load %opencl.block** %kernelBlock, align 4
  %call62 = call spir_func i32 @_Z14enqueue_kernel9ocl_queuei9ndrange_tU13block_pointerFvvE(%opencl.queue_t* %46, i32 241, %struct.ndrange_t* byval %ndrange, %opencl.block* %47)
  store i32 %call62, i32* %enq_res, align 4
  %48 = load i32* %enq_res, align 4
  %cmp63 = icmp ne i32 %48, 0
  br i1 %cmp63, label %if.then64, label %if.end67

if.then64:                                        ; preds = %if.then57
  %49 = load i32* %linearId, align 4
  %50 = load i32* %maxGlobalWorkSize.addr, align 4
  %rem65 = urem i32 %49, %50
  %51 = load i32 addrspace(1)** %res.addr, align 4
  %arrayidx66 = getelementptr inbounds i32 addrspace(1)* %51, i32 %rem65
  store i32 -1, i32 addrspace(1)* %arrayidx66, align 4
  br label %if.end68

if.end67:                                         ; preds = %if.then57
  br label %if.end68

if.end68:                                         ; preds = %if.end67, %if.then64, %lor.lhs.false54, %lor.lhs.false, %sw.epilog, %if.then
  ret void
}

declare spir_func i32 @_Z13get_global_idj(i32) #1

declare spir_func i32 @_Z20get_global_linear_idv() #1

declare spir_func %opencl.queue_t* @get_default_queue() #1

; Function Attrs: nounwind
define internal spir_func void @__block_fn_block_invoke(i8* %.block_descriptor) #0 {
entry:
  %.block_descriptor.addr = alloca i8*, align 4
  %block.addr = alloca <{ i32, i32, i32 addrspace(1)*, i32 addrspace(1)* }>*, align 4
  store i8* %.block_descriptor, i8** %.block_descriptor.addr, align 4
  %0 = load i8** %.block_descriptor.addr
  %block = bitcast i8* %.block_descriptor to <{ i32, i32, i32 addrspace(1)*, i32 addrspace(1)* }>*
  store <{ i32, i32, i32 addrspace(1)*, i32 addrspace(1)* }>* %block, <{ i32, i32, i32 addrspace(1)*, i32 addrspace(1)* }>** %block.addr, align 4
  %block.capture.addr = getelementptr inbounds <{ i32, i32, i32 addrspace(1)*, i32 addrspace(1)* }>* %block, i32 0, i32 0
  %1 = load i32* %block.capture.addr, align 4
  %block.capture.addr1 = getelementptr inbounds <{ i32, i32, i32 addrspace(1)*, i32 addrspace(1)* }>* %block, i32 0, i32 1
  %2 = load i32* %block.capture.addr1, align 4
  %block.capture.addr2 = getelementptr inbounds <{ i32, i32, i32 addrspace(1)*, i32 addrspace(1)* }>* %block, i32 0, i32 2
  %3 = load i32 addrspace(1)** %block.capture.addr2, align 4
  %block.capture.addr3 = getelementptr inbounds <{ i32, i32, i32 addrspace(1)*, i32 addrspace(1)* }>* %block, i32 0, i32 3
  %4 = load i32 addrspace(1)** %block.capture.addr3, align 4
  call spir_func void @block_fn(i32 %1, i32 %2, i32 addrspace(1)* %3, i32 addrspace(1)* %4)
  ret void
}

declare %opencl.block* @spir_block_bind(i8*, i32, i32, i8*)

declare spir_func i32 @_Z26get_kernel_work_group_sizeU13block_pointerFvvE(%opencl.block*) #1

declare spir_func void @_Z10ndrange_1Djj(%struct.ndrange_t* sret, i32, i32) #1

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture readonly, i32, i32, i1) #2

declare spir_func void @_Z10ndrange_2DPKjS0_(%struct.ndrange_t* sret, i32*, i32*) #1

declare spir_func void @_Z10ndrange_3DPKjS0_(%struct.ndrange_t* sret, i32*, i32*) #1

declare spir_func i32 @_Z15get_global_sizej(i32) #1

declare spir_func i32 @_Z10atomic_incPVU3AS1i(i32 addrspace(1)*) #1

declare spir_func i32 @_Z14enqueue_kernel9ocl_queuei9ndrange_tU13block_pointerFvvE(%opencl.queue_t*, i32, %struct.ndrange_t* byval, %opencl.block*) #1

; Function Attrs: nounwind
define spir_kernel void @enqueue_mix_wg_size_single(i32 addrspace(1)* %res, i32 %level, i32 %maxGlobalWorkSize, i32 addrspace(1)* %rnd) #0 {
entry:
  %res.addr = alloca i32 addrspace(1)*, align 4
  %level.addr = alloca i32, align 4
  %maxGlobalWorkSize.addr = alloca i32, align 4
  %rnd.addr = alloca i32 addrspace(1)*, align 4
  store i32 addrspace(1)* %res, i32 addrspace(1)** %res.addr, align 4
  store i32 %level, i32* %level.addr, align 4
  store i32 %maxGlobalWorkSize, i32* %maxGlobalWorkSize.addr, align 4
  store i32 addrspace(1)* %rnd, i32 addrspace(1)** %rnd.addr, align 4
  %0 = load i32* %level.addr, align 4
  %1 = load i32* %maxGlobalWorkSize.addr, align 4
  %2 = load i32 addrspace(1)** %rnd.addr, align 4
  %3 = load i32 addrspace(1)** %res.addr, align 4
  call spir_func void @block_fn(i32 %0, i32 %1, i32 addrspace(1)* %2, i32 addrspace(1)* %3)
  ret void
}

attributes #0 = { nounwind "less-precise-fpmad"="true" "no-frame-pointer-elim"="false" "no-infs-fp-math"="true" "no-nans-fp-math"="true" "no-realign-stack" "stack-protector-buffer-size"="8" "unsafe-fp-math"="true" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="true" "no-frame-pointer-elim"="false" "no-infs-fp-math"="true" "no-nans-fp-math"="true" "no-realign-stack" "stack-protector-buffer-size"="8" "unsafe-fp-math"="true" "use-soft-float"="false" }
attributes #2 = { nounwind }

!opencl.kernels = !{!0}
!opencl.enable.FP_CONTRACT = !{}
!opencl.spir.version = !{!7}
!opencl.ocl.version = !{!8}
!opencl.used.extensions = !{!9}
!opencl.used.optional.core.features = !{!9}
!opencl.compiler.options = !{!9}
!llvm.ident = !{!10}

!0 = !{void (i32 addrspace(1)*, i32, i32, i32 addrspace(1)*)* @enqueue_mix_wg_size_single, !1, !2, !3, !4, !5, !6}
!1 = !{!"kernel_arg_addr_space", i32 1, i32 0, i32 0, i32 1}
!2 = !{!"kernel_arg_access_qual", !"none", !"none", !"none", !"none"}
!3 = !{!"kernel_arg_type", !"int*", !"int", !"int", !"int*"}
!4 = !{!"kernel_arg_base_type", !"int*", !"int", !"int", !"int*"}
!5 = !{!"kernel_arg_type_qual", !"", !"", !"", !""}
!6 = !{!"kernel_arg_name", !"res", !"level", !"maxGlobalWorkSize", !"rnd"}
!7 = !{i32 1, i32 2}
!8 = !{i32 2, i32 0}
!9 = !{}
!10 = !{!"clang version 3.6.1 "}
