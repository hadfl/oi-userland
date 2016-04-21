#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#

#
# Copyright (c) 2013, Oracle and/or its affiliates. All rights reserved.
#

Puppet::Type.newtype(:pkg_mediator) do
    @doc = "Manage Oracle Solaris package mediators"

    ensurable

    newparam(:name) do
        desc "The mediator name"
        isnamevar
    end

    newproperty(:version) do
        desc "The version of the mediated interface to use"
        newvalues(/none/io,/\A\d+(?:\.\d+){0,}\Z/)
        munge do |value|
          return value.downcase.capitalize.to_sym if value.match(/none/i)
          value
        end
    end

    newproperty(:implementation) do
        desc "The implementation of the mediated interface to use"
        newvalues(/none/io,/\A[[:alnum:]]+\Z/,/\A[[:alnum:]]+@(?:\d+(?:\.\d+){0,})\Z/)
        munge do |value|
          return value.downcase.capitalize.to_sym if value.match(/none/i)
          value
        end
    end

    validate {
      if self[:version] == :None && self[:implementation] == :None
        fail("Version and Implementation cannot both be :None use ensure => :absent instead")
      end
    }
end
