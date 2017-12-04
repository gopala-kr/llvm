; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:   --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:   --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl
; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py

@glob = common local_unnamed_addr global i8 0, align 1

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_iltsc(i8 signext %a, i8 signext %b) {
; CHECK-LABEL: test_iltsc:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    sub [[REG:r[0-9]+]], r3, r4
; CHECK-NEXT:    rldicl r3, [[REG]], 1, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i8 %a, %b
  %conv2 = zext i1 %cmp to i32
  ret i32 %conv2
}

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_iltsc_sext(i8 signext %a, i8 signext %b) {
; CHECK-LABEL: test_iltsc_sext:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    sub [[REG:r[0-9]+]], r3, r4
; CHECK-NEXT:    sradi r3, [[REG]], 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i8 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_iltsc_sext_z(i8 signext %a) {
; CHECK-LABEL: test_iltsc_sext_z:
; CHECK:       srawi r3, r3, 31
; CHECK-NEXT:  blr
entry:
  %cmp = icmp slt i8 %a, 0
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

; Function Attrs: norecurse nounwind
define void @test_iltsc_store(i8 signext %a, i8 signext %b) {
; CHECK-LABEL: test_iltsc_store:
; CHECK:       # BB#0: # %entry
; CHECK:         sub [[REG:r[0-9]+]], r3, r4
; CHECK:         rldicl {{r[0-9]+}}, [[REG]], 1, 63
entry:
  %cmp = icmp slt i8 %a, %b
  %conv3 = zext i1 %cmp to i8
  store i8 %conv3, i8* @glob, align 1
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_iltsc_sext_store(i8 signext %a, i8 signext %b) {
; CHECK-LABEL: test_iltsc_sext_store:
; CHECK:       # BB#0: # %entry
; CHECK:         sub [[REG:r[0-9]+]], r3, r4
; CHECK:         sradi {{r[0-9]+}}, [[REG]], 63
entry:
  %cmp = icmp slt i8 %a, %b
  %conv3 = sext i1 %cmp to i8
  store i8 %conv3, i8* @glob, align 1
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_iltsc_sext_z_store(i8 signext %a) {
; CHECK-LABEL: test_iltsc_sext_z_store:
; CHECK: srwi {{r[0-9]+}}, r3, 7
entry:
  %cmp = icmp slt i8 %a, 0
  %conv2 = sext i1 %cmp to i8
  store i8 %conv2, i8* @glob, align 1
  ret void
}