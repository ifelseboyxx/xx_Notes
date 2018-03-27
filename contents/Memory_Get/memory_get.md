# 正确地获取 iOS 应用占用的内存

当我们想去获取 iOS 应用的占用内存时，通常我们能找到的方法是这样的，用 `resident_size`：

```
- (int64_t)memoryUsage {
    int64_t memoryUsageInByte = 0;
    struct task_basic_info taskBasicInfo;
    mach_msg_type_number_t size = sizeof(taskBasicInfo);
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t) &taskBasicInfo, &size);
    
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) taskBasicInfo.resident_size;
        NSLog(@"Memory in use (in bytes): %lld", memoryUsageInByte);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kernelReturn));
    }
    return memoryUsageInByte;
}
```

也有这样的：

```
- (int64_t)currentAppMemory {
    struct mach_task_basic_info info;
    mach_msg_type_number_t count = MACH_TASK_BASIC_INFO_COUNT;
    
    int r = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &count);
    if (r == KERN_SUCCESS) {
        return info.resident_size;
    }else{
        return -1;
    }
}
```
**但是无论哪一种，和 Xcode 上显示的内存都不对不上，关于这个问题[这里](https://github.com/aozhimin/iOS-Monitor-Platform/issues/5)还讨论过。**

最近又发现了这篇文章 [http://www.samirchen.com/ios-app-memory-usage/](http://www.samirchen.com/ios-app-memory-usage/)，里面不是拿的 `resident_size` 而是 `phys_footprint`，发现基本上和 Xcode 上的内存占用显示对上了：

```
- (int64_t)memoryUsageX {
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        return vmInfo.phys_footprint;
    } else {
        return -1;
    }
}
```

关于 `phys_footprint` 可以看看[这里](https://github.com/apple/darwin-xnu/blob/master/osfmk/kern/task.c)的解释：

```
/*
 * phys_footprint
 *   Physical footprint: This is the sum of:
 *     + (internal - alternate_accounting)
 *     + (internal_compressed - alternate_accounting_compressed)
 *     + iokit_mapped
 *     + purgeable_nonvolatile
 *     + purgeable_nonvolatile_compressed
 *     + page_table
 *
 * internal
 *   The task's anonymous memory, which on iOS is always resident.
 *
 * internal_compressed
 *   Amount of this task's internal memory which is held by the compressor.
 *   Such memory is no longer actually resident for the task [i.e., resident in its pmap],
 *   and could be either decompressed back into memory, or paged out to storage, depending
 *   on our implementation.
 *
 * iokit_mapped
 *   IOKit mappings: The total size of all IOKit mappings in this task, regardless of
     clean/dirty or internal/external state].
 *
 * alternate_accounting
 *   The number of internal dirty pages which are part of IOKit mappings. By definition, these pages
 *   are counted in both internal *and* iokit_mapped, so we must subtract them from the total to avoid
 *   double counting.
 */
```

