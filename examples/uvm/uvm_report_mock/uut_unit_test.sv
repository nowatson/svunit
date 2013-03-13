//###############################################################
//
//  Licensed to the Apache Software Foundation (ASF) under one
//  or more contributor license agreements.  See the NOTICE file
//  distributed with this work for additional information
//  regarding copyright ownership.  The ASF licenses this file
//  to you under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in compliance
//  with the License.  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.
//
//###############################################################

`include "uvm_macros.svh"
`include "svunit_uvm_mock_defines.sv"

`include "svunit_defines.svh"

import uvm_pkg::*;
import svunit_pkg::*;
import svunit_uvm_mock_pkg::*;

`include "uut.sv"
typedef class c_uut_unit_test;

module uut_unit_test;
  c_uut_unit_test unittest;
  string name = "uut_ut";

  function void setup();
    unittest = new(name);
  endfunction
endmodule

class c_uut_unit_test extends svunit_testcase;

  //===================================
  // This is the class that we're 
  // running the Unit Tests on
  //===================================
  uut my_uut;


  //===================================
  // Constructor
  //===================================
  function new(string name);
    super.new(name);

    my_uut = new("uut");
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    super.setup();

    uvm_report_mock::setup();
  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    super.teardown();
    /* Place Teardown Code Here */
  endtask


  //===================================
  // All tests are defined between the
  // SVUNIT_TESTS_BEGIN/END macros
  //
  // Each individual test must be
  // defined between `SVTEST(_NAME_)
  // `SVTEST_END(_NAME_)
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END(mytest)
  //===================================
  `SVUNIT_TESTS_BEGIN


  //--------------------------------------------
  // test: _99_is_an_error
  // desc: when 99 is passed in, there should be
  //       an errors flagged. We expect that
  //       error by first calling the
  //       uvm_report_mock::expect_error()
  //--------------------------------------------
  `SVTEST(_99_is_an_error)
    uvm_report_mock::expect_error();
    my_uut.verify_arg_is_not_99(99);

    `FAIL_IF(!uvm_report_mock::verify_complete());
  `SVTEST_END(_99_is_an_error)


  //--------------------------------------------
  // test: other_numbers_are_not_an_error
  // desc: no other 8-bit numbers should cause
  //       an error
  //--------------------------------------------
  `SVTEST(other_numbers_are_not_an_error)
    for (int i=0; i<=255; i+=1) begin
      if (i != 99) my_uut.verify_arg_is_not_99(i);
    end

    `FAIL_IF(!uvm_report_mock::verify_complete());
  `SVTEST_END(other_numbers_are_not_an_error)


  //---------------------------------------------
  // test: _99_has_a_specific_message
  // desc: the error message for 99 has specific
  //       text that we want to verify. We can
  //       do that by passing args into the
  //       expect_error(MSG, ID) function
  //---------------------------------------------
  `SVTEST(_99_has_a_specific_message)
    uvm_report_mock::expect_error("arg is 99!", "uut");
    my_uut.verify_arg_is_not_99(99);

    `FAIL_IF(!uvm_report_mock::verify_complete());
  `SVTEST_END(_99_has_a_specific_message)


  `SVUNIT_TESTS_END

endclass

