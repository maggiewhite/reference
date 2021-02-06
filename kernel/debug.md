Note: all of this assumes you're working on Android, some of it might assume you're working with a
qualcomm chip.

## Logging
You can get kernel logs via:
```
dmesg > dmesg.txt
```

Clear dmesg via:
```
dmesg -C
```

### Dynamic debug
Enable additional logging via [dynamic debug](https://www.kernel.org/doc/html/latest/admin-guide/dynamic-debug-howto.html).

**Note:** It's necessary for `CONFIG_DYNAMIC_DEBUG` to have been configured in the device config (usually located
at `arch/arm64/configs/` for mobile devices).

- See all of the potential logs you can enable via:

    ```
    cat /d/dynamic_debug/control
    # filename:lineno [module]function flags format
    ...
    sound/core/pcm.c:351 [snd_pcm]snd_pcm_proc_info_read =_ "snd_pcm_proc_info_read: cannot malloc\012"
    ```

- Grep for the specific file you care about (ex. sound/core/pcm.c), and enable logs like so:

    ```
    echo 'module snd_pcm +p' > /d/dynamic_debug/control
    echo 'file sound/core/pcm.c +p' > /d/dynamic_debug/control
    echo 'file sound/core/* +p' > /d/dynamic_debug/control
    ```

- Then enable verbose printk logging:
    ```
    echo 8 > /proc/sys/kernel/printk
    ```

- And collect your logs via `dmesg`. Note that all of above reset on reboot.

Resources:
- https://www.kernel.org/doc/html/latest/admin-guide/dynamic-debug-howto.html

## Device tree
During runtime, device tree parameters can be found at `/sys/firmware/devicetree/base`. Keep in mind
that these are binary values, so non-string values won't print without being piped through `xxd`.
Ex:

    ```
    cat /sys/firmware/devicetree/base/soc/devfreq-cpufreq/m4m-cpufreq/target-dev | xxd
    ```
Device tree files can be found in the kernel code at `arch/arm64/boot/dts`.

Note: device-tree-compiler would be useful, but not usually available on Android. Use it like so:

    ```
    dtc -I fs /sys/firmware/devicetree/base
    ```

Resources:
- http://books.gigatux.nl/mirror/kerneldevelopment/0672327201/ch16lev1sec6.html

## Configurable runtime module parameters
Set up a configurable parameter in a kernel module like the following example:

    ```
    #include <linux/moduleparam.h>
    static <type> <name>=<default>;
    module_param(<name>,<moduleparam type>,<linux file permissions>);
    static int irq=10;
    module_param(irq,int,0660);
    static char *devname = "example";
    module_param(devname,charp,0660);
    ```

Read or write to that parameter via `/sys/module/<module_name>/parameters/`, where the default
module name is the filename without an extension. Supported types can be found in
`include/linux/moduleparam.h`, search for `#define module_param(`.

Resources:
- http://books.gigatux.nl/mirror/kerneldevelopment/0672327201/ch16lev1sec6.html

## DebugFS
A good way to pass info between the kernel and userspace for debug. Kernel documentation for this
is pretty good:
https://www.kernel.org/doc/html/latest/filesystems/debugfs.html

A quick example:

    ```
    #include <linux/debugfs.h>
    struct device_struct {
        struct device dev;
        struct dentry *dentry;
    };

    static struct dentry *base_dir;
    static int __init debugfs_init(void)
    {
        base_dir = debugfs_create_dir("my_dir", NULL);
        return base_dir ? -ENOMEM : 0;
    }

    static ssize_t debugfs_read(struct file *file, char __user *ubuf,
                                       size_t cnt, loff_t *ppos)
    {
        int ret;
        char buf[100];
        struct device_struct *dev = file->private_data;

        ret = snprintf(buf, sizeof(buf), "%s\n", "value");
        return simple_read_from_buffer(ubuf, cnt, ppos, buf, ret);
    }

    static const struct file_operations debugfs_fops = {
        .open = simple_open,
        .read = debugfs_read,
        .write = debugfs_write,
    };

    int init(struct device *in_dev)
    {
        struct device_struct *dev_struct = container_of(in_dev, struct device_struct, dev);
        int ret = 0;
        ret = debugfs_init();
        if (ret < 0)
            goto error;
        dev_struct->dentry = debugfs_create_file("name", S_IRUGO | S_IWUSR, base_dir, dev_struct,
                                                  &debugfs_fops);
        return 0;
    error:
        debugfs_remove_recursive(base_dir);
        return -1;
    }
    ```

Resources:
 - https://linux-kernel-labs.github.io/refs/heads/master/labs/device_drivers.html#read-and-write
 - https://www.kernel.org/doc/html/latest/filesystems/debugfs.html

## Performance
CPU scheduler configurations can be found at `/sys/devices/system/cpu/cpu*/cpufreq/`. You can tell
the big and little cores apart by comparing `cpuinfo_max_freq`. You can also `cat related_cpus` to
see which cores are related.

Modify the governer on related cores by checking the available ones via 
`cat scaling_available_governors`, then here's an example to set frequency to max:

    ```
    echo performance > /sys/devices/system/cpu/cpuX/scaling_governer
    ```

### Enable ftrace events
First: read `/d/tracing/README`

Enabling/disabling is done via `echo [0|1] > /d/tracing/.../enable`. Some interesting things to
enable:

    ```
    echo 1 > /d/tracing/events/irq/enable
    echo 1 > /d/tracing/events/sched/sched_wakeup/enable
    ```

The easiest way to get a trace on Android is via systrace:

    ```
    python2.7 ~/Library/Android/sdk/platform-tools/systrace/systrace.py -o systrace.html
    ```

Resources:
 - https://source.android.com/devices/tech/debug/ftrace#enabling_events
 - https://github.com/brendangregg/perf-tools
 - https://jvns.ca/blog/2017/03/19/getting-started-with-ftrace/

## Qualcomm ADSP logs
https://github.com/kevinmehall/nano-dm can get DSP logs without qualcomm tooling.
